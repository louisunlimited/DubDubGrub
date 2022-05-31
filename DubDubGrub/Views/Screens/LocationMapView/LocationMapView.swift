//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import CoreLocationUI
import SwiftUI
import MapKit

struct LocationMapView: View {
    
    // A reference to the locationManager in DubDubGrubApp.swift
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationViewModel()
    @Environment(\.dynamicTypeSize) var DynamicTypeSize
    
    var body: some View {
        ZStack (alignment: .top) {
            
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
            
            LogoView(frameWidth: 125)
                .shadow(radius: 10)
            //  .accessibilityHidden(true)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationView {
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: DynamicTypeSize)
                    .toolbar {
                        Button("Dismiss") {
                            viewModel.isShowingDetailView = false
                        }
                    }
            }
        }
        .overlay(alignment:.bottomLeading) {
            // Press button for location
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
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
        LocationMapView().environmentObject(LocationManager())
    }
}
