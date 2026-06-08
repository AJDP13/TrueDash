//
//  DiskView.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 08/06/2026.
//

import SwiftUI

struct DiskView: View{
	@Bindable var DashboardVM: DashboardViewModel
	
	var body: some View{
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
		.padding()
		.sheet(isPresented: $DashboardVM.showDiskInfo, onDismiss: DashboardVM.hideDiskInfoPopup){
			DiskCardPopup(diskInfo: DashboardVM.currentDiskInfo)
				.presentationDetents([.medium])
		}
	}
}
