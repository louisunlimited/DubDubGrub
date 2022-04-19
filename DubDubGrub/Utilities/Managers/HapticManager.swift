//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Louis Qian on 4/18/22.
//

import UIKit

struct Hapticmanager {
    static func playSuccess() {
        let genrator = UINotificationFeedbackGenerator()
        // .success .error etc -> different types of haptic
        genrator.notificationOccurred(.success)
    }
}
