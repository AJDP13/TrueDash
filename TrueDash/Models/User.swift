//
//  User.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

struct User: Codable{
	var id: Int
	var uid: Int
	var username: String
	var unixhash: String
	var smbhash: String
	var home: String
	var full_name: String
	var builtin: Bool
	var smb: Bool
	var groups: [Int]
	var password_disabled: Bool
	var ssh_password_enabled: Bool
	var locked: Bool
	var email: String
	var local: Bool
	var immutable: Bool
	var twofactor_auth_configured: Bool
	var password_change_required: Bool
	var roles: [String]
	var api_keys: [String]
}
