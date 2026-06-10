//
//  AppDetailView.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 10/06/2026.
//

import SwiftUI

struct AppDetailView: View {
	@State var app: TrueNASApp
	var appService: AppService
	@Bindable var session: AppSession
	
	@State private var loading: Bool = false
	@State private var loadingMsg: String = ""
	
	private func canStopApp(state: AppState) -> Bool{
		switch state{
			case .stopped:
				return false
			case .stopping:
				return false
			case .deploying:
				return false
			default:
				return true
		}
	}
	
	private func performAction(
		message: String,
		action: @escaping () async throws -> Void
	) async {
		do {
			loadingMsg = message
			loading = true
			defer { loading = false }

			try await action()

			loadingMsg = "Fetching updated app data"
			app = try await appService.getAppStatus(id: app.id)

		} catch {
			session.currentError = error
		}
	}
	
    var body: some View {
		if loading {
			VStack{
				ProgressView()
				Text(loadingMsg)
			}
		}else {
			VStack{
				Text(app.name)
					.font(.title)
				
				Text("Current Version: \(app.version)")
				Text("App Status: \(app.state.rawValue)")
				
				if let lv = app.latest_version{
					Text("Latest Version Available: \(lv)")
				}
				
				
				
				Spacer()
				
				HStack{
					Button("Stop App"){
						Task{
							await performAction(message: "Stopping App"){
								try await appService.stopApp(id: app.id)
							}
						}
					}
					.buttonStyle(.glassProminent)
					.disabled(!canStopApp(state: app.state))
					
					Spacer()
					
					Button("Start App"){
						Task{
							await performAction(message: "Starting App"){
								try await appService.startApp(id: app.id)
							}
						}
					}
					.buttonStyle(.glassProminent)
					.disabled(app.state != .stopped)
					
					Spacer()
					
					Button("Upgrade App"){
						Task{
							await performAction(message: "Upgrading App"){
								try await appService.upgradeApp(id: app.id)
							}
						}
					}
					.buttonStyle(.glass)
					.disabled(!app.upgrade_available)
				}
				.disabled(loading)
			}
			.padding()
			.task {
				while true {
					do {
						app = try await appService.getAppStatus(id: app.id)
					} catch {
						session.currentError = error
					}

					try? await Task.sleep(for: .seconds(5))
				}
			}
			.toolbar{
				ToolbarItem(placement: .topBarTrailing){
					Button {
					   Task {
						   try await appService.getAppStatus(id: app.id)
					   }
				   } label: {
					   Image(systemName: "arrow.clockwise")
				   }
				}
			}
//			.task{
//				while !Task.isCancelled {
//					try? await Task.sleep(for: .seconds(10))
//					try await appService.getAppStatus(id: app.id)
//				}
//			}
		}
    }
}

#Preview {
	let app = TrueNASApp(name: "Jellyfin", id: "jellyfin-id", state: .runnning, upgrade_available: true, image_updates_available: false, custom_app: true, version: "1.2.1", portals: ["Web UI":"https://aerotrixlabs.com"])
	let session = AppSession()
	AppDetailView(app: app, appService: AppService(client: TrueNASClient()), session: session)
}
