//
//  JSONRPCResponse.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 05/06/2026.
//

struct JSONRPCResponse<T: Codable>: Codable{
	let result: T?
	let id: Int
	let error: JSONRPCError?
}

struct JSONRPCError: Codable {
	let code: Int
	let message: String
	let data: JSONRPCErrorData?
}

struct JSONRPCErrorData: Codable {
	let error: Int?
	let errname: String?
	let reason: String?
}
