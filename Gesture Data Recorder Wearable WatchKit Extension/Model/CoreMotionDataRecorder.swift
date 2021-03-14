//
//  CoreMotionDataRecorder.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import CoreMotion
import os

struct CoreMotionDataRecorder {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    var activity: Int = 0
    
    var motionDataHandler: ((CMDeviceMotion) -> ())?
    
    func enableMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            os_log(.debug, log: Log.watch, "Motion updated unavailable on phone")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1 / Config.smaplesPerSecond
        
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: queue) { motionData, error in
            guard let motionData = motionData else {
                let errorText = error?.localizedDescription ?? "Unknown"
                print("Watch motion update error: \(errorText)")
                return
            }
            motionDataHandler?(motionData)
        }
    }
    
    func disableMotionupdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
