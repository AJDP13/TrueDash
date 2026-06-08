//
//  ContentView.swift
//  TrueDash
//
//  Created by Arun Dutta-Plummer on 04/06/2026.
//

import SwiftUI

struct ContentView: View {
	@State private var appSession: AppSession;
	@State private var vm: ConnectionViewModel;
	
	init(){
		let session = AppSession()
		
		_appSession = State(initialValue: session)
		
		_vm = State(initialValue: ConnectionViewModel(session: session));
	}
	
    var body: some View {
		switch appSession.authState {
			case .undefined:
				UndefinedAuthStateView(vm: vm)
			case .authenticating:
				AuthenticatingAuthStateView()
			case .authenticated:
				AuthenticatedAuthStateView(session: appSession)
			case .notAuthenticated:
				UnAuthenticatedAuthStateView(vm: vm);
		}
    }
}

struct UndefinedAuthStateView: View{
	@Bindable var vm: ConnectionViewModel;
	
	var body: some View{
		NavigationStack{
			Form{
				TextField("Host", text:$vm.host)
				SecureField("Api Key", text: $vm.apiKey)
				Button("Connect"){
					Task{
						await vm.connect()
					}
				}
			}
			.navigationTitle("TrueNAS API Authentication")
		}
	}
}

struct AuthenticatedAuthStateView: View{
	@Bindable var session: AppSession;
	var body: some View{
		NavigationStack{
			Dashboard(appSession: session);
		}
	}
}

struct AuthenticatingAuthStateView: View{
	var body: some View{
		VStack{
			ProgressView()
			Text("Authenticating");
		}
	}
}

struct UnAuthenticatedAuthStateView: View{
	@Bindable var vm: ConnectionViewModel;
	
	var body: some View{
		VStack{
			Image(systemName: "person.fill.xmark")
				.foregroundStyle(.red)
			Text("You're logged out")
			
			Button("Sign In"){
				vm.signOut()
			}
			.buttonStyle(.bordered)
		}
	}
}

#Preview {
    ContentView()
}
