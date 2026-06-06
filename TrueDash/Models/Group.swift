//
//  Group.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

struct Group: Codable{
	var id: Int
	var gid: Int
	var name: String
	var builtin: Bool
	var smb: Bool
	var group: String
	var local: Bool
	var users: [Int]
	var roles: [Int]
	var immutable: Bool
}
