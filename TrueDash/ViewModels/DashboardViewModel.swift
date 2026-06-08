//
//  DashboardViewModel.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 05/06/2026.
//

import Foundation

@Observable
final class DashboardViewModel{
	var systemInfo: SystemInfo?;
	var disks: DiskList?;
	var diskTemperatures: DiskTemperatures = [:];
	var isLoading: Bool = true;
	
	var currentDiskInfo: DiskInfo?
	var showDiskInfo: Bool = false;
	
	var errorMessage: String?
	
	var diskInfo: [DiskInfo]{
		guard let disks else {return []}
		
		return disks.used.map{disk in
			DiskInfo(disk: disk, temperature: diskTemperatures[disk.name] ?? nil)
		}
	}
	
	var session: AppSession;
	var client: TrueNASClient;
	var dashService: DashboardService;
	
	init(session: AppSession){
		self.session = session;
		self.client = session.client;
		self.dashService = DashboardService(client: session.client);
	}
	
	func load() async{
		do{
			try await session.ensureConnected();
			systemInfo = try await dashService.getSystemInfo()
			disks = try await dashService.getDisks()
			diskTemperatures = try await dashService.getDiskTemps()
		}catch{
			print(error);
			errorMessage = error.localizedDescription
		}
	}
	
	func setCurrentDiskInfo(d: DiskInfo){
		self.currentDiskInfo = d
	}
	
	func showDiskInfoPopup(){
		self.showDiskInfo = true
	}
	
	func hideDiskInfoPopup(){
		self.showDiskInfo = false
	}
}
