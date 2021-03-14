//
//  MotionProviderType.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 12/3/21.
//

import Foundation

enum MotionProviderType: String, CaseIterable {
    case phone, watch
    
    var glyph: String {
        switch self {
        case .phone: return "📱"
        case .watch: return "⌚️"
        }
    }
}
