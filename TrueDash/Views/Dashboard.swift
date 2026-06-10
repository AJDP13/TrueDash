//
//  Dashboard.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import SwiftUI

struct Dashboard: View {
	@Bindable var appSession: AppSession;
	@State private var DashboardVM : DashboardViewModel;
	
	init(appSession: AppSession){
		self.appSession = appSession;
		DashboardVM = DashboardViewModel(session: appSession);
	}
	
    var body: some View {
		if !DashboardVM.initDone {
			VStack{
				Spacer()
				
				ProgressView()
				Text("Loading TrueNAS Data...")
				
				Spacer()
				
				Button("Cancel"){
					appSession.logout()
				}
				.buttonBorderShape(.capsule)
				.foregroundStyle(.red)
			}
			.task{
				await DashboardVM.initLoad()
			}
		}else{
			VStack{
				Text(DashboardVM.systemInfo?.hostname ?? "Unknown Host Name")
					.font(.title)
				Text(appSession.host)
					.font(.subheadline)
				
				Spacer()
				
				if let sysInfo = DashboardVM.systemInfo{
					CPUOverview(systemInfo: sysInfo)
				}
				
				Spacer()
				
				List{
					NavigationLink{
						AppView(DashboardVM: DashboardVM, session: appSession)
					} label:{
						RowView(icon: "app.badge", text: "Apps")
					}
					
					NavigationLink{
						DiskView(DashboardVM: DashboardVM)
					} label:{
						RowView(icon: "externaldrive", text: "Disks"){
//								Text("\(DashboardVM.disks?.used.count ?? 0) Disks used")
//									.font(.caption2)
						}
					}
					
					NavigationLink{
						Text("TODO: Pools View")
					} label:{
						RowView(icon: "externaldrive.connected.to.line.below", text: "Pools")
					}
					
					NavigationLink{
						Text("TODO: VM View")
					} label:{
						RowView(icon: "desktopcomputer", text: "Virtual Machines")
					}
				}
				.navigationTitle("Apps")
				
				Spacer()
			}
			.alert(
				"Error",
				isPresented: Binding(get: {DashboardVM.errorMessage != nil}, set: {_ in DashboardVM.errorMessage = nil})
			){
				Button("OK"){
					DashboardVM.errorMessage = nil
				}
			} message:{
				Text(DashboardVM.errorMessage ?? "")
			}
		
			.navigationBarTitleDisplayMode(.inline)
			.toolbar{
				DashboardToolbar(DashboardVM: DashboardVM, appSession: appSession)
			}
			.task{
				while !Task.isCancelled {
					try? await Task.sleep(for: .seconds(10))
					await DashboardVM.load()
				}
			}
		}
    }
}

#Preview {
	let appSession: AppSession = {
		let session = AppSession()
		session.host = "192.168.1.155"
		session.apiKey = "6-KuP10wYlD9tqN38Fm2bPGIcm8xeemyBQCA1aPOqrTtL92PGHvN6xkVf9nu1KDa2W"
		Task{
			do{
				try await session.ensureConnected()
			}catch{
				print(error)
			}
		}
		return session
	}()
	
	Dashboard(appSession: appSession)
}
