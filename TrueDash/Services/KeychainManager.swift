//
//  KeychainManager.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import Foundation
import Security

final class KeychainManager {

	static let shared = KeychainManager()

	private init() {}

	// MARK: - Save

	func save(value: String, for key: String) -> Bool {

		guard let data = value.data(using: .utf8) else {
			return false
		}

		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecValueData as String: data
		]

		// Remove existing item first
		SecItemDelete(query as CFDictionary)

		let status = SecItemAdd(
			query as CFDictionary,
			nil
		)

		return status == errSecSuccess
	}

	// MARK: - Load

	func load(for key: String) -> String? {

		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]

		var result: AnyObject?

		let status = SecItemCopyMatching(
			query as CFDictionary,
			&result
		)

		guard
			status == errSecSuccess,
			let data = result as? Data,
			let value = String(data: data, encoding: .utf8)
		else {
			return nil
		}

		return value
	}

	// MARK: - Delete

	func delete(for key: String) {

		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key
		]

		SecItemDelete(query as CFDictionary)
	}

	// MARK: - Convenience

	func saveServer(
		host: String,
		apiKey: String
	) {

		save(value: host, for: "truenas_host")
		save(value: apiKey, for: "truenas_api_key")
	}

	func loadHost() -> String? {
		load(for: "truenas_host")
	}

	func loadApiKey() -> String? {
		load(for: "truenas_api_key")
	}

	func clearServer() {
		delete(for: "truenas_host")
		delete(for: "truenas_api_key")
	}
}
