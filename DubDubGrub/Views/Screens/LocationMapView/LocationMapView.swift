//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    // A reference to the locationManager in DubDubGrubApp.swift
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
            }
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingOnbardView, onDismiss: viewModel.checkIfLocationServicesIsEnabled, content: {
            OnBoardView(isShowingOnBoardView: $viewModel.isShowingOnbardView)
        })
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissedButton)
        })
        .onAppear {
            viewModel.runStartupChecks()
            
            //We don't want to get this everytime
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
