//
//  AppSession.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

import Foundation

enum SessionError: Error{
	case authenticationFailed
}

@Observable
final class AppSession{
	let client: TrueNASClient = TrueNASClient();
	var authService:TrueNASAuthService;
	var host: String = "";
	var apiKey: String = "";
	
	var currentError: Error?
	
	var authState: AppAuthState = .undefined;
	var serverAuthState: ServerAuthState = .notAuthenticated;
	
	init(){
		authService = TrueNASAuthService(client: client)
	}
	
	func ensureConnected() async throws{
		if client.connectionState == .connected{
			return
		}
		
		try client.connect(host:host)
		
		let authenticated = try await authService.authenticate(apiKey: apiKey)
		
		guard authenticated else{
			throw SessionError.authenticationFailed
		}
	}
	
	func logout(){
		print("Logging Out")
		self.client.disconnect()
		self.authState = .undefined
		self.serverAuthState = .notAuthenticated
	}
}
