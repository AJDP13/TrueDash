//
//  DashboardToolbar.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 08/06/2026.
//

import SwiftUI

struct DashboardToolbar: ToolbarContent{
	@Bindable var DashboardVM: DashboardViewModel;
	@Bindable var appSession: AppSession;
	
	var body: some ToolbarContent{
		ToolbarItem(placement: .topBarLeading){
			Button {
			   Task {
				   await DashboardVM.load()
			   }
		   } label: {
			   Image(systemName: "arrow.clockwise")
		   }
		}

		ToolbarItem(placement: .topBarTrailing){
			Button {
				appSession.logout()
		   } label: {
			   Text("Log Out")
		   }
		}
	}
}
