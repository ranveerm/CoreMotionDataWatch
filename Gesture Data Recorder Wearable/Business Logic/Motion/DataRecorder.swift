//
//  DataRecorder.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation
import WatchConnectivity
import os

class DataRecorder {
    // MARK: - Data
    var activityData: [String] = []
    private(set) var numberOfActionsRecorded = 0
    // TODO: Accept user input for below
    private(set) var numberOfActionsToRecord = 1
    
    // Motion Information Provider
    private(set) var deviceMotionProvider: DeviceMotionProvider?
    /** Convenienve property to check is any of the devices can provide motion data. */
    var isMotionProviderAvailable: Bool {
        if let _ = deviceMotionProvider { return true }
        else { return false }
    }
    
    init() {
        // Initially settiing motion provider type to watch to activate watch session (which is used to check if watch applicaiton is in the foreground)
        setMotionProviderType(.watch)
        // Swithcing over to phone as motion provider as it is unlikely that the user has the watching App open while starting the phone App
        setMotionProviderType(.phone)
    }
    
    /**
     Set the motion provider for from available `MotionProviderType`
     
     - Important: If the motion provider does not have the capability to provide motion data, fall through to an alternative provider (eg. phone -> watch). If none of the providers are capable of providing motion data, set the `deviceMotionProvider` value to `nil`
     */
    func setMotionProviderType(_ motionProviderType: MotionProviderType) {
        switch motionProviderType {
        case .phone:
            if PhoneMotionProvider().isDeviceMotionCapabilityAvailable {
                os_log(.debug, log: Log.motion, "Successful in setting up the phone to provide Core Motion data")
                deviceMotionProvider = PhoneMotionProvider()
            } else { deviceMotionProvider = nil }
        case .watch:
            deviceMotionProvider = WatchMotionProvider(handleIncapableMotionDevice: {
                self.setMotionProviderType(.phone)
            })
        }
    }
    
    func initialiseActionsToRecord(_ numberOfActionsToRecord: Int) {
        numberOfActionsRecorded = 0
        self.numberOfActionsToRecord = numberOfActionsToRecord
    }
    
    func incrementNumberOfActionsRecorded() {
        numberOfActionsRecorded += 1
    }
}
