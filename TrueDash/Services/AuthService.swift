//
//  AuthService.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

import Foundation

final class TrueNASAuthService{
	private let client: TrueNASClient;
	
	init(client: TrueNASClient){
		self.client = client
	}
	
//	func authenticate(
//		apiKey: String,
//		completion: @escaping (Bool) -> Void
//	){
//		client.call(
//			method: "auth.login_with_api_key",
//			params: [apiKey]
//		){ result in
//			switch result{
//				case .success(let data):
//					do{
//						let response = try JSONDecoder().decode(
//							JSONRPCResponse<Bool>.self,
//							from:data
//						)
//						print(response.result);
//						completion(response.result);
//					}catch{
//						completion(false);
//					}
//				case .failure:
//					completion(false);
//			}
//		}
//	}
	
	func authenticate(
		apiKey: String
	) async throws -> Bool{
		return try await client.call(method: "auth.login_with_api_key", params:[apiKey]);
	}
}
