//
//  TrueNASClient.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import Foundation

enum ServerAuthState{
	case authenticated, notAuthenticated;
}

enum AppAuthState{
	case undefined, authenticating, authenticated, notAuthenticated;
}

enum ClientError: Error{
	case invalidURL, notConfigured;
}

private struct RPCEnvelope: Decodable{
	let id: Int
}

enum ConnectionState{
	case disconnected, connecting, connected
}

final class TrueNASClient {
	private var socket: URLSessionWebSocketTask?
	private let session: URLSession;
	private var nextRequestID: Int = 1;
	private(set) var connectionState: ConnectionState = .disconnected
	
	var host: String = "";
	
	private var pendingRequests: [Int: (Result<Data, Error>) -> Void] = [:]
	
	init(){
		let delegate = TrueNASSessionDelegate()

			self.session = URLSession(
				configuration: .default,
				delegate: delegate,
				delegateQueue: nil
			)
	}
	
	private func getRequestId() -> Int{
		defer{nextRequestID += 1}
		return self.nextRequestID;
	}
	
	func connect(host: String) throws{
		guard let url = URL(string: "wss://\(host)/api/current") else{
			throw ClientError.invalidURL;
		}
		
		self.host = host;
		self.connectionState = .connecting;
		
		socket = session.webSocketTask(with: url);
		socket?.resume();
		self.connectionState = .connected;
		self.receive();
	}
	
	
	func disconnect(){
		socket?.cancel(with: .normalClosure, reason: nil);
		socket = nil
		self.connectionState = .disconnected;
	}
	
	func receive(){
		socket?.receive{ result in
			switch result{
				case .success(let message):
					let text:String
					
					switch message{
						case .string(let str):
							text=str
						case .data(let data):
							text = String(data:data, encoding:.utf8) ?? ""
							
						@unknown default:
							return
					}
					
					self.handleMessage(text);
					
					self.receive();
				case .failure(let failure):
					print("Websocket receive failed: ", failure);
					self.connectionState = .disconnected
					self.disconnect();
			}
		}
	}
	
	func send(request: JSONRPCRequest){
		do{
			let data = try JSONEncoder().encode(request);
			
			guard let json = String( data:data, encoding:.utf8) else{
				return;
			}
			
			print("Sending: \(json)")
			
			socket?.send(.string(json)){error in
				if let error=error{
					print(error)
				}
			}

		}catch{
			print(error)
		}
	}
	
	func call<T: Codable>(
		method: String,
		params: [String] = []
	) async throws -> T {

		let id = getRequestId()

		let request = JSONRPCRequest(
			id: id,
			method: method,
			params: params
		)

		return try await withCheckedThrowingContinuation { continuation in

			pendingRequests[id] = { result in
				print(result);

				switch result {

				case .success(let data):
						
					print(data)
						
					do {

						let response = try JSONDecoder().decode(
							JSONRPCResponse<T>.self,
							from: data
						)

						continuation.resume(
							returning: response.result
						)

					} catch {
						continuation.resume(
							throwing: error
						)
					}

				case .failure(let error):
					print(error)
					continuation.resume(
						throwing: error
					)
				}
			}

			self.send(request: request)
		}
	}
	
	private func handleMessage(_ text: String){
		guard let data = text.data(using: .utf8) else{
			return
		}
		
		guard let envelope = try? JSONDecoder()
			.decode(RPCEnvelope.self, from: data) else{
			return
		}
		
		guard let completion = pendingRequests.removeValue(forKey: envelope.id) else{
			return;
		}
		
		completion(.success(data));
		
	}
}
