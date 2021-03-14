//
//  ActivityType.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 4/3/21.
//

import Foundation
import SwiftUI
import AVFoundation

// ActivityType enum specifies what human activity we are currently recording
enum ActivityType: Int {
    case none, driveIt, shakeIt, chopIt
    
    static func returnActivityToDisplay() -> [ActivityType] {
        [.driveIt, .shakeIt, .chopIt]
    }
    
    func returnActivityToDisplayView() -> some View {
        Text(self.description).tag(self.rawValue)
    }
    
    func reutrnVideoFileName() -> String {
        switch self {
        case .none: return "none"
        case .driveIt: return "drive_it_demo"
        case .shakeIt: return "shake_it_demo"
        case .chopIt: return "chop_it_demo"
        }
    }
    
    func utterance() -> AVSpeechUtterance {
        switch self {
        case .driveIt: return Utterances.driveIt
        case .shakeIt: return Utterances.shakeIt
        case .chopIt: return Utterances.chopIt
        default: return Utterances.error
        }
    }
}

extension ActivityType: CustomStringConvertible {
    var description: String {
        switch self {
        case .none: return "None"
        case .driveIt: return "Drive-it"
        case .shakeIt: return "Shake-it"
        case .chopIt: return "Chop-it"
        }
    }
}
