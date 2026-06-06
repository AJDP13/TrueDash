//
//  Untitled.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

struct SystemInfo: Codable{
	let version: String
	let hostname: String
	let model: String
	let cores: Int
	let physical_cores: Int
	let uptimte: String
	let uptime_seconds:Int
	let timezone: String
	let system_manufacturer: String
}
