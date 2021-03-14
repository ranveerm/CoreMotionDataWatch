//
//  File.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import os

private let subsystem = "com.ranveer.Gesture-Data-Recorder-Wearable"

struct Log {
    static let phone = OSLog(subsystem: subsystem, category: "Watch Debugging")
    static let phoneConnection = OSLog(subsystem: subsystem, category: "Phone Connection")
    static let watchConnection = OSLog(subsystem: subsystem, category: "Watch Connection")
    static let watch = OSLog(subsystem: subsystem, category: "Watch Debugging")
    static let dataManager = OSLog(subsystem: subsystem, category: "Data Manager")
    static let audioManager = OSLog(subsystem: subsystem, category: "Audio Manager")
    static let motion = OSLog(subsystem: subsystem, category: "Motion")
}
