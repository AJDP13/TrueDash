//
//  DashboardMenuRowView.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 08/06/2026.
//

import SwiftUI

struct RowView<Subtitle: View>: View{
	var icon: String
	var text: String
	
	let subtitleView: Subtitle

	init(
			icon: String,
			text: String,
			@ViewBuilder subtitleView: () -> Subtitle = {EmptyView()}
		) {
			self.icon = icon
			self.text = text
			self.subtitleView = subtitleView()
		}
	
	var body: some View{
		HStack{
			Image(systemName: icon)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 50)
				.padding()
			
			VStack{
				Text(text)
					.font(.default)
					.multilineTextAlignment(.leading)
				
				subtitleView
			}
			
			Spacer()
		}
	}
}

#Preview {
	NavigationStack{
		List{
			NavigationLink{
				Text("Test")
			} label:{
				RowView(icon: "externaldrive", text: "Disks")
			}
			NavigationLink{
				Text("Test 2")
			} label:{
				RowView(icon: "externaldrive", text: "Disks"){
					Text("7 Disks in use")
				}
			}
		}
	}
}
