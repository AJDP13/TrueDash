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
		VStack{
			Text("Dashboard")
				.font(.title)
			Button("Reload"){
				Task{
					//Reload upon request
					await DashboardVM.load();
				}
			}
			Text("Disks")
				.font(.title2)
			ScrollView{
				VStack{
					ScrollView(.horizontal){
						HStack{
							ForEach(DashboardVM.diskInfo){info in
								DiskCard(info:info)
									.onTapGesture {
										DashboardVM.setCurrentDiskInfo(d: info)
										DashboardVM.showDiskInfoPopup()
									}
							}
						}
					}
				}
			}
			.sheet(isPresented: $DashboardVM.showDiskInfo, onDismiss: DashboardVM.hideDiskInfoPopup){
				DiskCardPopup(diskInfo: DashboardVM.currentDiskInfo)
					.presentationDetents([.medium])
			}
		}
		.task{
			await DashboardVM.load()
			//Load dashboard ViewModel data when Dashboard is in view
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
}

#Preview {
	Dashboard(appSession: AppSession())
}
