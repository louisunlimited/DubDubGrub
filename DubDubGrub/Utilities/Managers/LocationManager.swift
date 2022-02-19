//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Louis Qian on 1/24/22.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
}
