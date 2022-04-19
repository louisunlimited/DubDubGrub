//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/23/22.
//

import SwiftUI

extension View {
    
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
    
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    
    func embedInScrollView() -> some View {
        GeometryReader { geo in
            ScrollView {
                self.frame(minHeight: geo.size.height, maxHeight: .infinity)
            }
        }
    }
}
