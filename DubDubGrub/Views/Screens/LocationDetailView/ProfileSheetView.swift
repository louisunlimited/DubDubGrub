//
//  ProfileSheetView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 3/31/22.
//

import SwiftUI

// MARK: Alternative Profile Modal View for larger dynamic type sizes

struct ProfileSheetView: View {
    
    var profile: DDGProfile
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: profile.createAvatarImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
                
                Text(profile.firstName + " " + profile.lastName)
                    .font(.title2.weight(.bold))
                    .minimumScaleFactor(0.9)
                
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                
                Text(profile.bio)
                    .accessibilityLabel(Text("Bio, \(profile.companyName)"))
            }
            .padding()
        }
    }
}

struct ProfileSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSheetView(profile: DDGProfile(record: MockData.profile))
    }
}
