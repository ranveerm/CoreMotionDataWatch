//
//  ViewModelWatch.swift
//  Gesture Data Recorder Wearable WatchKit Extension
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import WatchConnectivity
import os
import CoreMotion
import WatchKit

protocol PhoneConnectivity {
    var session: WCSession { get }
    func sendData(data: String)
}

class PhoneConnectivityProvider : NSObject,  ObservableObject {
    @Published var sessionActive: Bool
    @Published var recordingState: RecordingState = .isNotRecording
    
    var session: WCSession
    var coreMotionDataRecorder = CoreMotionDataRecorder()
    
    init(session: WCSession = .default){
        self.session = session
        self.sessionActive = false
        
        super.init()
        
        self.session.delegate = self
        session.activate()
        coreMotionDataRecorder.motionDataHandler = { self.sendMessage([WatchCommunicationMessageTypes.motionData.rawValue: $0.extractRelevantDataToString()]) }
    }
    
    func updateState(_ activationState: Bool) {
        DispatchQueue.main.async {
            self.sessionActive = activationState
        }
    }
}

// MARK: - Protocol Conformance
extension PhoneConnectivityProvider: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        os_log(.debug, log: Log.watch, "Session activation complete")
        updateState(session.activationState == .activated)
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        os_log(.debug, log: Log.phone, "Watch session changed")
        updateState(session.activationState == .activated)
    }
}

// MARK: - Send/Receive Data
extension PhoneConnectivityProvider: PhoneConnectivity {
    func sendMessage(_ message: [String: Any]) {
        guard sessionActive == true else {
            os_log(.error, log: Log.phoneConnection, "Unable to send data from watch- session inactive")
            return
        }
        
        session.sendMessage(message, replyHandler: { payload in
            guard let messageReceivedResponse = payload[WatchCommunicationMessageTypes.messageReceivedResponse.rawValue] as? Bool else {
                return os_log(.error, log: Log.phoneConnection, "messageReceivedResponse is in an undecipherable form")
            }
            if messageReceivedResponse { os_log(.debug, log: Log.phoneConnection, "Successfully recieved message sent from watch") }
            else { os_log(.debug, log: Log.phoneConnection, "Error in receiving message sent from watch") }
        }, errorHandler: { error in
            os_log(.error, log: Log.phoneConnection, "Unsuccessful in sending message from watch: \(error.localizedDescription)")
        })
    }
    
    func sendData(data: String) {
        os_log(.debug, log: Log.watch, "Packaging motion data to send to phone")
        let message = [WatchCommunicationMessageTypes.motionData.rawValue: data]
        sendMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        handleMessage(message)
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handleMessage(userInfo)
    }
}

extension PhoneConnectivityProvider {
    func handleMessage(_ message: [String : Any]) {
        for (key, value) in message {
            switch key {
            case WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue:
                let isDeviceMotionActive = self.coreMotionDataRecorder.motionManager.isDeviceMotionAvailable
                sendMessage([WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue: isDeviceMotionActive])
            case WatchCommunicationMessageTypes.recordingState.rawValue:
                guard let recordingState = value as? String else {
                    os_log(.debug, log: Log.phoneConnection, "RecordingState received from phone in an unexpected format")
                    continue
                }
                handleRecordingstateMessage(recordingState)
            default:
                os_log(.error, log: Log.phoneConnection, "Message from phone is undecipherable")
            }
        }
    }
    
    func handleRecordingstateMessage(_ recordingState: String) {
        switch recordingState {
        case RecordingState.prepareToRecord(recordingMetadata: .emptyContainer).id: updateRecordingState(RecordingState.prepareToRecord(recordingMetadata: .emptyContainer))
        case RecordingState.isRecording.id:
            self.coreMotionDataRecorder.enableMotionUpdates()
            WKInterfaceDevice.current().play(.start)
            updateRecordingState(RecordingState.isRecording)
        case RecordingState.finishedRecording.id:
            self.coreMotionDataRecorder.disableMotionupdates()
            WKInterfaceDevice.current().play(.stop)
            updateRecordingState(RecordingState.finishedRecording)
        case RecordingState.unableToRecord(message: "").id: updateRecordingState(RecordingState.unableToRecord(message: ""))
        default: os_log(.debug, log: Log.phoneConnection, "RecordingState received from phone in an unexpected format")
        }
    }
    
    func updateRecordingState(_ recordingState: RecordingState) {
        DispatchQueue.main.async {
            self.recordingState = recordingState
        }
    }
}
