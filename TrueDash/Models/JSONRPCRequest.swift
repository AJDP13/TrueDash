//
//  JSONRPCRequest.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import Foundation

struct JSONRPCRequest: Codable{
	var jsonrpc: String = "2.0"
	var id:Int;
	var method: String;
	var params: [String];
}
