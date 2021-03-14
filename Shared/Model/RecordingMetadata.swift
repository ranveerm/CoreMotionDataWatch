//
//  RecordingMetadata.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation

struct RecordingMetadata {
    let userID: String
    let sessionID: String
    let motionProviderType: MotionProviderType
    let activityType: ActivityType
    
    let numberOfActivitySessionsToRecord: Int
}

extension RecordingMetadata {
    func enrichData(_ data: String) -> String {
        sessionID + "," + activityType.description + "," + data
    }
}

extension RecordingMetadata {
    static let emptyContainer: RecordingMetadata = RecordingMetadata(userID: "", sessionID: "", motionProviderType: .watch, activityType: .none, numberOfActivitySessionsToRecord: 0)
}
