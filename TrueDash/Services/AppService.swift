//
//  AppService.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

final class AppService{
	private var client: TrueNASClient;
	
	
	init(client: TrueNASClient){
		self.client = client;
	}
	
	func listApps() async throws -> [TrueNASApp] {
		return try await client.call(method: "app.query", params:[]);
	}
}
