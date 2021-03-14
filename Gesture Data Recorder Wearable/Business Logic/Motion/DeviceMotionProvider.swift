//
//  DeviceMotionProvider.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation

protocol DeviceMotionProvider {
    var motionProviderType: MotionProviderType { get }
    var  queue: OperationQueue { get }
    
    var activityType: ActivityType { get set }
    
    func recordMotionUpdates(processData: @escaping (String) -> ())
    func stopMotionUpdates()
}
