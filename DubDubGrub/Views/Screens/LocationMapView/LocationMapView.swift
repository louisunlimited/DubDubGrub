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
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(location: location
                                  , number: viewModel.checkedInProfiles[location.id, default: 0])
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            
                            if let _ = locationManager.selectedLocation {
                                viewModel.isShowingDetailView = true
                            }
                        }
                }
            }
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView {
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar {
                        Button("Dismiss") {
                            viewModel.isShowingDetailView = false
                        }
                        .accentColor(.brandPrimary)
                    }
            }
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissedButton)
        })
        .onAppear {
            //We don't want to get this everytime
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
            viewModel.getCheckedInCount()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
