//
//  ConnectionViewModel.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import Foundation

@Observable
final class ConnectionViewModel {
	var host = KeychainManager.shared.loadHost() ?? "";
	var apiKey = KeychainManager.shared.loadApiKey() ?? ""
	var conencted: Bool = false;
	
	private let client: TrueNASClient;
	private let session: AppSession;
	private let authService: TrueNASAuthService;
	
	init(session: AppSession){
		self.session = session;
		self.client = session.client;
		self.authService = TrueNASAuthService(client: client);
	}
	
	@MainActor
	func connect() async {
		session.authState = .authenticating;
		
		do{
			try client.connect(host: host);
			
			let authenticated = try await authService.authenticate(apiKey: apiKey)
			
			if(authenticated){
				KeychainManager.shared.saveServer(host:host, apiKey: apiKey);
				session.host = host;
				session.apiKey = apiKey;
				session.authState = .authenticated
				print("Authenticated");
			}else{
				session.authState = .notAuthenticated
				print("Unssuccessful Auth")
			}
		}catch{
			print(error);
			session.authState = .notAuthenticated;
		}
	}
	
	func signOut(){
		session.authState = .undefined;
	}
	
	
}
