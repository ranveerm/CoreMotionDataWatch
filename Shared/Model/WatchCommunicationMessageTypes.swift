//
//  WatchCommunicationMessageTypes.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 12/3/21.
//

import Foundation

enum WatchCommunicationMessageTypes: String {
    case isDeviceMotionCapabilityAvailable
    case motionData
    case messageReceivedResponse
    case recordingState
}
