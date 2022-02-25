//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
    
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem{
                    Label("Map", systemImage: "map")
                }
            
            LocationListView()
                .tabItem{
                    Label("Locations", systemImage: "building")
                }
            
            NavigationView {
                ProfileView()
            }
            .tabItem{
                Label("Profile", systemImage: "person")
            }
        }
        .onAppear{
            CloudKitManager.shared.getUserRecord()
            viewModel.runStartupChecks()
        } // Get user profile once opened
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnbardView, onDismiss: viewModel.checkIfLocationServicesIsEnabled, content: {
            OnBoardView(isShowingOnBoardView: $viewModel.isShowingOnbardView)
        })
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
        
    }
}
