//
//  AppView.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 10/06/2026.
//

import SwiftUI

struct AppView: View {
	@Bindable var DashboardVM: DashboardViewModel
	@Bindable var session: AppSession
	
	@State private var searchText = ""
	
	var filteredApps: [TrueNASApp] {
		if searchText.isEmpty {
			return DashboardVM.apps
		}

		return DashboardVM.apps.filter {
			$0.name.localizedCaseInsensitiveContains(searchText)
		}
	}
	
	private func badgeColor(for state: AppState) -> Color {
		switch state {
		case .crashed:
			.red
		case .deploying:
			.yellow
		case .runnning:
				.green
		default:
			.primary
		}
	}

    var body: some View {
		NavigationStack{
			List{
				ForEach(filteredApps){app in
					NavigationLink{
						AppDetailView(app: app, appService: DashboardVM.appService, session: session)
					} label:{
						HStack{
							Text(app.name)
							if app.upgrade_available{
								Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
									.foregroundStyle(.orange)
							}
							
							if app.custom_app{
								Image(systemName: "hammer.circle")
									.foregroundStyle(.blue)
							}
							
							Spacer()
							
							Text(app.state.rawValue)
								.foregroundStyle(badgeColor(for: app.state))
						}
					}
				}
			}
			.searchable(text: $searchText, prompt: "Search apps")
		}
	}
}

#Preview {
	let D: DashboardViewModel = DashboardViewModel(session: AppSession())
	let apps = [
		TrueNASApp(name: "Jellyfin", id: "jellyfin-id", state: .runnning, upgrade_available: true, image_updates_available: false, custom_app: true, version: "1.2.1", portals: ["Web UI":"https://aerotrixlabs.com"]),
		TrueNASApp(name: "truenas", id: "truenas-id", state: .deploying, upgrade_available: false, image_updates_available: false, custom_app: true, version: "1.2.1", portals: ["Portal":"https://aerotrixlabs.com"]),
		TrueNASApp(name: "Other app", id: "otjer-id", state: .crashed, upgrade_available: false, image_updates_available: false, custom_app: false, version: "1.2.1", portals: ["Other UI":"https://aerotrixlabs.com"]),
		TrueNASApp(name: "Other app2", id: "otj2er-id", state: .stopped, upgrade_available: true, image_updates_available: false, custom_app: false, version: "1.2.1", portals: ["Other UI":"https://aerotrixlabs.com"])
	]
	D.apps = apps
	let session = AppSession()
	return AppView(DashboardVM: D, session: session)
}
