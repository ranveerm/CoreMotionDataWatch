//
//  PhoneMotionProvider.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation
import CoreMotion
import os

struct PhoneMotionProvider: DeviceMotionProvider {
    var motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    var activityType: ActivityType = .none
    
    var motionProviderType: MotionProviderType = .phone
    var isDeviceMotionCapabilityAvailable: Bool {
        motionManager.isDeviceMotionAvailable
    }
    
    func recordMotionUpdates(processData: @escaping (String) -> ()) {
        motionManager.deviceMotionUpdateInterval = 1 / Config.smaplesPerSecond
        
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { motionData, error in
            guard let motionData = motionData else {
                let errorText = error?.localizedDescription ?? "Unknown"
                os_log(.error, log: Log.watchConnection, "Motion updates error: \(errorText)")
                return
            }
            processData(motionData.extractRelevantDataToString())
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
