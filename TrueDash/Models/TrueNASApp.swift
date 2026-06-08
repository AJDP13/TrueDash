//
//  TrueNASApp.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 07/06/2026.
//

enum AppState: String, Codable{
	case runnning = "RUNNING"
	case crashed = "CRASHED"
	case deploying = "DEPLOYING"
	case stopped = "STOPPED"
	case stopping = "STOPPING"
}

struct TrueNASApp: Codable, Identifiable{
	var name: String
	var id: String
	var state: AppState
	var upgrade_available: Bool
	var latest_version: String?
	var image_updates_available: Bool
	var custom_app: Bool
	var version: String
	var metadata: AppMetadata?
	var notes: String?
	var portals: [String:String]
}

struct AppMetadata: Codable{
	var app_version: String?
	var icon: String
}
