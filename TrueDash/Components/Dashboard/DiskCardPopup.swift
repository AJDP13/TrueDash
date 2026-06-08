//
//  DiskCardPopup.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 07/06/2026.
//

import SwiftUI

struct DiskCardPopup: View{
	var diskInfo: DiskInfo?
	var temp: Double {
		self.diskInfo?.temperature ?? 0
	}
	
	var body: some View{
		if let diskInfo {
			VStack{
				
				Text(diskInfo.disk.name)
					.font(.title2)
				
				HStack{
					Gauge(value: temp, in: 20...70){
						Text("Disk Temperature")
					} currentValueLabel: {
						Text("\(Int(temp))°C")
					} minimumValueLabel: {
						Text("20")
					} maximumValueLabel: {
						Text("70")
					}
					.gaugeStyle(.accessoryCircular)
					.tint(Gradient(stops: [
						.init(color: .green, location: 0.0),
					   .init(color: .green, location: 0.3),
					   .init(color: .yellow, location: 0.6),
						.init(color: .red, location: 0.9)
				   ]))
				}
				
				Text("Serial Number: \(diskInfo.disk.serial)")
				Text("Model: \(diskInfo.disk.model ?? "Unknown")")
				Text("Description: \(diskInfo.disk.descr ?? "Unavailable")")
				Text("Pool: \(diskInfo.disk.imported_zpool ?? "None")")
			}
		}else {
			VStack{
				Spacer()
				Image(systemName: "externaldrive.badge.xmark")
					.foregroundStyle(.red)
				Text("No Disk Currently Selected")
				Spacer()
			}
		}
	}
}

#Preview {
	let disk = Disk(name: "Test Disk Name", driver: "Driver", serial: "SN1237", bus: "ADA");
	let diskInfo = DiskInfo(disk: disk, temperature: 34)
	DiskCardPopup(diskInfo: diskInfo)
}
