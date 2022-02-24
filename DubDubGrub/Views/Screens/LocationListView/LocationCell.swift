//
//  LocationCell.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

struct LocationCell: View {
    
    var location: DDGLocation
    var profiles: [DDGProfile]
    
    var body: some View {
        HStack {
            Image(uiImage: location.createSquareImage())
                .resizable()
                .scaledToFit()
                .frame(width:80, height:80)
                .clipShape(Circle())
                .padding(.vertical, 8)
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title2.weight(.semibold))
                    .lineLimit(1)
                //Shrink to 0.75 without ...
                    .minimumScaleFactor(0.75)
                
                
                if profiles.isEmpty {
                    Text("Nobody is checked in")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                } else {
                    HStack {
                        ForEach(profiles.indices, id: \.self) {index in
                            if index <= 3 {
                                AvatarView(image: profiles[index].createAvatarImage(), size: 35)
                            } else if index == 4 {
                                AdditionalProfilesView(number: profiles.count - 4)
                            }
                        }
                    }
                }
                
            }
            .padding(.leading)
        }
    }
}

struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(location: DDGLocation(record: MockData.location), profiles: [])
    }
}

struct AdditionalProfilesView: View {
    
    var number: Int
    
    var body: some View {
        Text("+\(number)")
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .clipShape(Circle())
    }
    
}