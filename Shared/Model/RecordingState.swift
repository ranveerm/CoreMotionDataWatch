//
//  RecordingState.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation

enum RecordingState: Identifiable {
    case prepareToRecord(recordingMetadata: RecordingMetadata)
    case isRecording
    case finishedRecording
    case isNotRecording
    case unableToRecord(message: String)
    
    func checkIfRecording() -> Bool {
        switch self {
        case .isRecording: return true
        default: return false
        }
    }
    
    func shouldPhoneUIBeDisabled() -> Bool {
        switch self {
        case .prepareToRecord, .isRecording: return true
        default: return false
        }
    }
    
    var id: String {
        switch self {
        case .prepareToRecord: return "Preparing to record"
        case .isRecording: return "Recording"
        case .finishedRecording: return "Finished recording"
        case .isNotRecording: return "Not Recording"
        case .unableToRecord: return "Unable to record"
        }
    }
}
