//
//  TrueNASSessionDelegate.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import Foundation

final class TrueNASSessionDelegate:
	NSObject,
	URLSessionDelegate
{
	func urlSession(
		_ session: URLSession,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping (
			URLSession.AuthChallengeDisposition,
			URLCredential?
		) -> Void
	) {

		if let trust = challenge.protectionSpace.serverTrust {

			completionHandler(
				.useCredential,
				URLCredential(trust: trust)
			)

			return
		}

		completionHandler(
			.performDefaultHandling,
			nil
		)
	}
}
