//
//  TrueNASError.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 11/06/2026.
//

import Foundation

enum TrueNASError: LocalizedError {
	case unauthorized
	case network
	case disconnected
	case invalidResponse
	case server(String)

	var errorDescription: String? {
		switch self {
		case .unauthorized:
			return "You do not have permission to perform this action."

		case .network:
			return "Unable to connect to the TrueNAS server."

		case .disconnected:
			return "Connection to the TrueNAS server was lost."

		case .invalidResponse:
			return "The server returned an invalid response."

		case .server(let message):
			return message
		}
	}
}
