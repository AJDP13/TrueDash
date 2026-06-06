//
//  DashboardService.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 05/06/2026.
//

final class DashboardService{
	private var client: TrueNASClient;

	
	init(client: TrueNASClient){
		self.client = client;
	}
	
	func getSystemInfo()async throws -> SystemInfo{
		return try await client.call(method: "system.info", params:[])
	}
	
	func getDisks() async throws -> DiskList{
		return try await client.call(method: "disk.details", params:[])
	}
	
	func getDiskTemps() async throws -> DiskTemperatures{
		return try await client.call(method: "disk.temperatures", params:[]);
	}
}
