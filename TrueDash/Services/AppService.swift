//
//  AppService.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

struct TrueNASApp: Codable{
	let id: String;
	let name: String;
}

final class AppService{
	private var client: TrueNASClient;
	
	
	init(client: TrueNASClient){
		self.client = client;
	}
	
	func listApps() -> [TrueNASApp] {
		return []
	}
}
