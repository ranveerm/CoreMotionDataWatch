//
//  WatchConnectivityProviderBasic.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 13/3/21.
//

import Foundation
import WatchConnectivity
import os

class WatchConnectivityProviderBasic: NSObject, WatchConnectivity {
    var session: WCSession
    var isReachable: Bool { session.isReachable }
    var isActive: Bool { session.activationState == .activated }
    var messageReceivedCompletionHandler: (([String : Any]) -> Void)? {
        // This property handles incomming messages, while also being optional. Hence, there is a situation where an incomming message from watch is not handled. This is expecially a problem if the message is to check device capability. Hence, a property observer is set to send a message to check for device capability whenever the property is set.
        didSet { if isActive { communicateWithWatch(initialMessage) } }
    }
    // Initial Message value is irrelevant, as the key is used as a query
    var initialMessage: [String : Any] = [WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue: ""]
    
    init(session: WCSession = .default) {
        self.session = WCSession.default
        super.init()
        
        self.session.delegate = self
        // When motion providers are swapped, a watch session might already be actvie, resulting in the relevant delegate method that sends initial message to not be invoked
        if !(session.activationState == .activated) { session.activate() }
    }
    
    func communicateWithWatch(_ message: [String : Any]) {
        if session.isReachable {
            // TODO: Implement replyHandler and error handler
            session.sendMessage(message, replyHandler: { _ in }, errorHandler: { _ in })
        } else {
            session.transferUserInfo(message)
        }
    }
    
    func setMessageReceivedCompletionHandler(_ messageReceivedCompletionHandler: @escaping (([String : Any]) -> Void)) {
        self.messageReceivedCompletionHandler = messageReceivedCompletionHandler
    }
}

extension WatchConnectivityProviderBasic: WCSessionDelegate {
    var failureToSetupProviderMessage: [String: Any] { [WatchCommunicationMessageTypes.isDeviceMotionCapabilityAvailable.rawValue: false] }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            os_log(.error, log: Log.watchConnection, "Error while activating watch session: \(error.localizedDescription)")
            messageReceivedCompletionHandler?(failureToSetupProviderMessage)
        }
        if session.activationState == .activated && !session.isWatchAppInstalled {
            messageReceivedCompletionHandler?(failureToSetupProviderMessage)
        }
        
        os_log(.debug, log: Log.watchConnection, "Watch session activation complete. Currecntly reachable: \(session.isReachable)")
    }
    
    // TODO: Implement switching between different devices
    func sessionDidBecomeInactive(_ session: WCSession) {
        os_log(.debug, log: Log.watchConnection, "Watch session became inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        os_log(.debug, log: Log.watchConnection, "Watch session became deactivated")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        os_log(.debug, log: Log.watchConnection, "Watch session reachability changed\n\t Currently reachable: \(session.isReachable)")
    }
}

extension WatchConnectivityProviderBasic {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        messageReceivedCompletionHandler?(message)
    }
}
