//
//  WatchMotionProvider.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation
import os


struct WatchMotionProvider: DeviceMotionProvider {
    var motionProviderType: MotionProviderType = .watch
    let queue = OperationQueue()
    
    var activityType: ActivityType = .none

    var watchConnectivity: WatchConnectivity
    var handleIncapableMotionDevice: () -> ()
    
    init(handleIncapableMotionDevice: @escaping () -> (), _ watchConnectivity: WatchConnectivity = WatchConnectivityProviderBasic()) {
        self.watchConnectivity = watchConnectivity
        self.handleIncapableMotionDevice = handleIncapableMotionDevice
        
        self.watchConnectivity.messageReceivedCompletionHandler = trivialMessagHandler
        
        // TODO: Launching the app on the watch provides a more direct feedback to the user. However, this required setting up the relevant Healthkit entitlement
//        let healthkitStore = HKHealthStore()
//        healthkitStore.startWatchApp(with: HKWorkoutConfiguration(), completion: { success , error in
//            if let error = error { os_log(.debug, log: Log.watchConnection, "Error while starting watch from phone: \(error.localizedDescription)") }
//
//            if success { os_log(.debug, log: Log.watchConnection, "Successfully booted up watch application from phone") }
//            else { os_log(.debug, log: Log.watchConnection, "Unsuccessful in booting up watch application from phone") }
//        })
    }
    
    /**
     Closure to handle processing of data is provided when the parent requests for motion data to be captured. Motion data is returned by the `WatchConnectivity`, however, this module should not be processing data or have any properties set to process data. As the current module is modelled as a struct, it's properties have not be modified to capture the closure provided when requesting motion capture data. Hence, a function is created to return a closure that can process data from the provider. The closure returned can assigned the relevant property of `WatchConnectivity`
     */
    func returnMessageHandler(processData: @escaping ((String) -> ())) -> (([String : Any]) -> Void) {
        return {  (message: [String: Any]) in
            for (messageKeys, messageData) in message {
                switch messageKeys {
                case WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue:
                    checkDeviceMotionCapability(messageData)
                case WatchCommunicationMessageTypes.motionData.rawValue:
                    guard let data = messageData as? String else {
                        os_log(.error, log: Log.watchConnection, "Data from watch is undecipherable")
                        return
                    }
                    os_log(.debug, log: Log.watchConnection, "Received motion data from watch")
                    processData(data)
                default:
                    os_log(.error, log: Log.watchConnection, "Message from watch is undecipherable")
                }
            }
        }
    }
    
    func trivialMessagHandler(_ message: [String: Any]) {
        for (messageKeys, messageData) in message {
            switch messageKeys {
            case WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue:
                checkDeviceMotionCapability(messageData)
            default:
                os_log(.error, log: Log.watchConnection, "Trivial message handler is not setup to handler the incomming message")
            }
        }
    }
    
    func checkDeviceMotionCapability(_ isCapable: Any) {
        guard let isDeviceMotionActive = isCapable as? Bool else {
            os_log(.error, log: Log.watchConnection, "Device capability information from watch is undecipherable")
            return
        }
        if !isDeviceMotionActive {
            os_log(.debug, log: Log.motion, "Watch is not capable of providing motion data, execuiting fallback")
            handleIncapableMotionDevice()
        } else {
            // TODO: Move the below log line to a more appropriate location as this method can be used for purposes other than setting up watch to provide Core Motion data
            os_log(.debug, log: Log.motion, "Successful in setting up the watch to provide Core Motion data")
        }
    }
    
    func recordMotionUpdates(processData: @escaping (String) -> ()) {
        // Note- motion provider requires data from `WatchConnectivity`
        watchConnectivity.setMessageReceivedCompletionHandler(returnMessageHandler(processData: processData))
//        watchConnectivity.setProcessData(processData)
        watchConnectivity.communicateWithWatch([WatchCommunicationMessageTypes.recordingState.rawValue: RecordingState.isRecording.id])
    }
    
    func stopMotionUpdates() {
        watchConnectivity.communicateWithWatch([WatchCommunicationMessageTypes.recordingState.rawValue: RecordingState.finishedRecording.id])
    }
}
