//
//  JSONRPCResponse.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 05/06/2026.
//

struct JSONRPCResponse<T: Codable>: Codable{
	let jsonrpc: String;
	let result: T;
	let id: Int;
}
