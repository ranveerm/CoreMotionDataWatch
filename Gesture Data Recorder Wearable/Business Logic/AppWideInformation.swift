//
//  AppWideInformation.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 9/3/21.
//

import Foundation
import WatchConnectivity
import CoreMotion
import os
import SwiftUI
import HealthKit

class AppWideInformation: ObservableObject {
    var isWatchAvailable: Bool { WCSession.isSupported() }
    
    var isWatchAppRunningAndInTheForeground: Bool { (WCSession.default.activationState == .activated && WCSession.default.isReachable) }
    
    private(set) var dataRecorder = DataRecorder()
}
