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
	
	func startApp(id: String) async throws -> EmptyResponse{
		return try await client.call(
			method: "app.start",
			params: [id]
		)
	}
	
	func stopApp(id: String) async throws -> EmptyResponse {
		return try await client.call(method: "app.stop", params: [id])
	}
	
	func upgradeApp(id:String) async throws -> EmptyResponse{
		return try await client.call(method: "app.upgrade", params: [id])
	}
	
	func getAppStatus(id: String) async throws -> TrueNASApp{
		return try await client.call(method: "app.get_instance", params: [id])
	}
}
