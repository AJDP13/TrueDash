//
//  Disk.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

import Foundation

enum DiskType: String, Codable{
	case SSD = "SSD";
	case HDD = "HDD";
}

struct Disk: Codable{
	var name: String
	var driver: String
	var size: Int?
	var serial: String
	var model: String?
	var descr: String?
	var bus: String
	var type: DiskType?
	var imported_zpool: String?
}

struct DiskList: Codable{
	var used: [Disk]
	var unused: [Disk]
}

typealias DiskTemperatures = [String: Double?]

struct DiskInfo: Identifiable{
	var id: String {disk.name}
	let disk: Disk
	let temperature: Double?
}
