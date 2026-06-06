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
	let client = TrueNASClient()
	var authService:TrueNASAuthService;
	var host: String = "";
	var apiKey: String = "";
	
	var authState: AppAuthState = .undefined;
	var serverAuthState: ServerAuthState = .notAuthenticated;
	
	init(){
		authService = TrueNASAuthService(client: client);
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
}
