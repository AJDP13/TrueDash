//
//  Dashboard.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import SwiftUI

struct Dashboard: View {
	@Bindable var appSession: AppSession;
	@State var DashboardVM : DashboardViewModel;
	
	init(appSession: AppSession){
		self.appSession = appSession;
		DashboardVM = DashboardViewModel(session: appSession);
	}
	
    var body: some View {
		if DashboardVM.isLoading {
			VStack{
				ProgressView()
				Text("Loading TrueNAS Data...")
			}
			.task{
				await DashboardVM.load()
				//Load dashboard ViewModel data when Dashboard is in view
			}
		}else{
			NavigationStack{
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
							List(DashboardVM.apps){app in
								Text(app.name)
							}
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
					}
					
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
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar{
				DashboardToolbar(DashboardVM: DashboardVM, appSession: appSession)
			}
		}
    }
}

#Preview {
	let appSession: AppSession = {
		let session = AppSession()
		session.host = "192.168.1.155"
		session.host = "192.168.1.155"
		session.apiKey = "6-KuP10wYlD9tqN38Fm2bPGIcm8xeemyBQCA1aPOqrTtL92PGHvN6xkVf9nu1KDa2W"
		do{
			Task{
				try await session.ensureConnected()
			}
		}catch{
			print(error)
		}
		return session
	}()
	
	NavigationStack{
		Dashboard(appSession: appSession)
	}
}
