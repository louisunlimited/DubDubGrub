//
//  LocationCell.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

struct LocationCell: View {
    
    var location: DDGLocation
    
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
                
                HStack {
                    AvatarView(image: PlaceHolderImage.avatar, size: 35)
                    AvatarView(image: PlaceHolderImage.avatar, size: 35)
                    AvatarView(image: PlaceHolderImage.avatar, size: 35)
                    AvatarView(image: PlaceHolderImage.avatar, size: 35)
                    AvatarView(image: PlaceHolderImage.avatar, size: 35)
                }
            }
            .padding(.leading)
        }
    }
}

struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(location: DDGLocation(record: MockData.location))
    }
}