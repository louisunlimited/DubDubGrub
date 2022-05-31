//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

struct LocationDetailView: View {
    
    // @ Stateobject - Initializing a new vm in this view
    // @ ObservedObject - relying on the data from the previous screen and the vm is passed from the previous screen
    @ObservedObject var viewModel: LocationDetailViewModel
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.BannerImage)
                
                HStack {
                    AddressView(address: viewModel.location.address)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                DiscriptionView(text: viewModel.location.description)
                
                HStack(spacing: 20) {
                    Button {
                        viewModel.getDirectionsToLocation()
                    } label: {
                        LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        
                    }
                    .accessibilityLabel(Text("Get Directions"))
                    
                    Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                        LocationActionButton(color: .brandPrimary, imageName: "network")
                        
                    })
                    .accessibilityRemoveTraits(.isButton)
                    .accessibilityLabel(Text("Go to website"))
                    
                    Button {
                        viewModel.callLocation()
                    } label: {
                        LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                    }
                    .accessibilityLabel(Text("Call location"))
                    if let _ = CloudKitManager.shared.profileRecordID {
                        Button {
                            viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                        } label: {
                            LocationActionButton(color: viewModel.buttonColor,
                                                 imageName: viewModel.buttonImageTitle)
                        }
                        .accessibilityLabel(Text(viewModel.buttonA11yLabel))
                        .disabled(viewModel.isLoading)
                        
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
                
                GridHeaderTextView(number: viewModel.checkedInProfiles.count)
                
                ZStack {
                    if viewModel.checkedInProfiles.isEmpty {
                        // Empty state
                        Text("😊 Check in and meet everyone")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: viewModel.determineColumns(for: dynamicTypeSize) , content: {
                                ForEach(viewModel.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            withAnimation{ viewModel.show(profile, in: dynamicTypeSize)}
                                            
                                        }
                                }
                            })
                        }
                    }
                    
                    if viewModel.isLoading { LoadingView() }
                }
                Spacer()
            }
            .accessibilityHidden(viewModel.isShowingProfileModal)
            
            if viewModel.isShowingProfileModal {
                Color(.black)
                    .ignoresSafeArea()
                    .opacity(0.9)
                //                    .transition(.opacity)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                    .accessibilityHidden(true)
                
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal,
                                 profile: viewModel.selectedProfile!)
                .transition(.opacity.combined(with: .slide))
                .zIndex(2)
            }
        }
        .task{
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .sheet(isPresented: $viewModel.isShowingProfileSheet) {
            NavigationView {
                ProfileSheetView(profile: viewModel.selectedProfile!)
                    .toolbar {
                        Button("Dismiss") {
                            viewModel.isShowingProfileSheet = false
                        }
                    }
            }
            
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert})
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(viewModel: LocationDetailView.LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle)))
        }
    }
}

fileprivate struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
            
        }
    }
}

fileprivate struct FirstNameAvatarView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var profile: DDGProfile
    
    var body: some View {
        VStack {
            AvatarView(image: profile.AvatarImage,
                       size: dynamicTypeSize >= .accessibility3 ? 100 : 64)
            
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Show \(profile.firstName)'s profile pop up"))
        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
    }
}

fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}

fileprivate struct AddressView: View {
    
    var address: String
    
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

fileprivate struct DiscriptionView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .minimumScaleFactor(0.75)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}


fileprivate struct GridHeaderTextView: View {
    var number: Int
    var body: some View {
        Text("Who's Here?")
            .font(.title2.weight(.bold))
            .padding(.top, 30)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(Text("Who's here? \(number) checked in."))
            .accessibilityHint(Text("Bottom section is scrollable"))
    }
}
