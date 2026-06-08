//
//  CPUOverview.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 08/06/2026.
//

import SwiftUI

struct CPUOverview: View{
	var systemInfo: SystemInfo
	
	var body: some View{
		ZStack{
			RoundedRectangle(cornerRadius: 25)
				.fill(.gray.opacity(0.5))
			
			VStack{
				Text(systemInfo.model)
					.font(.title3)
					.multilineTextAlignment(.leading)
				
				HStack{
					Text("Cores: \(systemInfo.physical_cores)")
						.font(.caption)
					
					Spacer()
					
					Text("Total Cores: \(systemInfo.cores)")
						.font(.caption)
				}
				
				Spacer()
				
				Text("Uptime: \(systemInfo.uptime)")
			}
			.padding()
		}
		.frame(width: 350, height: 150)
	}
}


#Preview {
	let systemInfo: SystemInfo = SystemInfo(version: "1.2.3", hostname: "AEROTRIXLABS", model: "Intel Core i5", cores: 5, physical_cores: 2, uptime: "5 days 4 minutes 35 seconds", uptime_seconds: 234347845, timezone: "UTC", system_manufacturer: "Intel")
	CPUOverview(systemInfo: systemInfo)
}
