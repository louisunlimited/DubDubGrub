//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI
import MapKit
import CloudKit

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @FocusState private var focusedTextField: ProfileTextField?
    
    enum ProfileTextField {
        case firstName, lastName, companyName, bio
    }
    
    var body: some View {
        ZStack{
            VStack {
                ZStack {
                    NameBackgroundView()
                    
                    HStack(spacing: 16) {
                        ZStack {
                            AvatarView(image: viewModel.avatar, size: 84)
                            EditImage()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel(Text("Profile Photo"))
                        .accessibilityHint(Text("Opens the iPhone's photo picker"))
                        .padding(.leading, 12)
                        .onTapGesture {
                            viewModel.isShowingPhotoPicker = true
                        }
                        
                        VStack(spacing: 1) {
                            TextField("First Name", text: $viewModel.firstName)
                                .profileNameStyle()
                                .focused($focusedTextField, equals: .firstName)
                                .onSubmit { focusedTextField = .lastName }
                                .submitLabel(.next)
                            TextField("Last Name", text: $viewModel.lastName)
                                .profileNameStyle()
                                .focused($focusedTextField, equals: .lastName)
                                .onSubmit { focusedTextField = .companyName }
                                .submitLabel(.next)
                            TextField("Company Name", text: $viewModel.companyName)
                                .focused($focusedTextField, equals: .companyName)
                                .onSubmit { focusedTextField = .bio }
                                .submitLabel(.next)
                            
                        }
                        .padding(.trailing, 16)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        CharactersRemainView(currentCount: viewModel.bio.count)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                        if viewModel.isCheckedIn {
                            Button {
                                viewModel.checkOut()
                            } label: {
                                 Label("Check Out", systemImage: "mappin.and.ellipse")
                                    .font(.system(size: 12,weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(height: 28)
                                    .background(Color.red)
                                    .cornerRadius(20)
                            }
                            .accessibilityLabel(Text("Check out of current location"))
                        }
                    }
                    
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1)
                        }
                        .accessibilityLabel(Text("Bio"))
                        .accessibilityHint(Text("This text field has a 100 character maximun"))
                        .focused($focusedTextField, equals: .bio)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button {
                    
                    viewModel.profileContext == .create ? viewModel.createProfile() : viewModel.updateProfile()
                }label: {
                    DDGButton(title: viewModel.profileContext == .create ? "Create Profile" : "Update Profile")
                }
                .padding(.bottom)
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button ("Dissmiss") {
                        focusedTextField = nil
                    }
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        // Fix different screen size
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .ignoresSafeArea(.keyboard)
            .onAppear(perform: {
                viewModel.getProfile()
                viewModel.getCheckedInStatus()
            })
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissedButton)
            })
            .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
                PhotoPicker(image: $viewModel.avatar)
            }
    }

}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            ProfileView()
        }
    }
}


struct NameBackgroundView: View {
    
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 128)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}


struct EditImage: View {
    
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y: 30)
    }
}

struct CharactersRemainView: View {
    
    var currentCount: Int
    
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : Color(.systemPink))
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}
