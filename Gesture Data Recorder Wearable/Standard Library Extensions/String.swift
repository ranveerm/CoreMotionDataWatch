//
//  String.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation

extension String {
    func addRecordingMetadata(_ recodringMetadata: RecordingMetadata) -> String {
        "\(recodringMetadata.sessionID)-1,\(recodringMetadata.motionProviderType.rawValue),\(recodringMetadata.activityType.rawValue)" + self
    }
}
