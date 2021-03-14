//
//  WatchManager.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import WatchConnectivity
import os
import CoreMotion

protocol WatchConnectivity {
    var session: WCSession { get }
    var isActive: Bool { get }
    var isReachable: Bool { get }
    var initialMessage: [String : Any] { get set }
    
    func communicateWithWatch(_ message: [String: Any])
    var messageReceivedCompletionHandler: (([String : Any]) -> Void)? { get set }
    func setMessageReceivedCompletionHandler(_ messageReceivedCompletionHandler: @escaping (([String : Any]) -> Void))
}
