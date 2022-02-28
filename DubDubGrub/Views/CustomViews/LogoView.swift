//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/25/22.
//

import SwiftUI

struct LogoView: View {
    
    var frameWidth: CGFloat
    
    var body: some View {
        // Initialize with decorative if we don't want voice over
        Image(decorative: "ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(frameWidth: 250)
    }
}
