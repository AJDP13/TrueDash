//
//  DiskCard.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 06/06/2026.
//

import SwiftUI

struct DiskCard: View{
	var info: DiskInfo
	
	var body: some View{
		GroupBox{
			VStack(alignment:.leading){
				Text(info.disk.name)
					.font(.headline)
				Text(info.disk.model ?? "")
					.font(.caption)
				Divider()
				Text("Size");
				Text(ByteCountFormatter.string(fromByteCount: Int64(info.disk.size ?? 0), countStyle: .binary))
				
				Text("Temperature")
				
				if let temp = info.temperature{
					Text("\(Int(temp))°C")
				}else{
					Text("N/A")
				}
			}
		}
		.frame(width: 180);
	}
}

#Preview {
	let disk: Disk = Disk(name: "abc", driver: "as", size: 500000, serial: "324234", model: "asdsd", descr: "asdasd", bus: "ADA", type: .HDD)
	let diskTemp: Double = 26.4;
	DiskCard(info: DiskInfo(disk: disk, temperature: diskTemp))
}
