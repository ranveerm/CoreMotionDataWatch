//
//  CMDeviceMotion.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import CoreMotion

extension CMDeviceMotion {
    func extractRelevantDataToString() -> String {
        """
        \(self.attitude.roll),\
        \(self.attitude.pitch),\
        \(self.attitude.yaw),\
        \(self.rotationRate.x),\
        \(self.rotationRate.y),\
        \(self.rotationRate.z),\
        \(self.gravity.x),\
        \(self.gravity.y),\
        \(self.gravity.z),\
        \(self.userAcceleration.x),\
        \(self.userAcceleration.y),\
        \(self.userAcceleration.z)
        """
    }
}
