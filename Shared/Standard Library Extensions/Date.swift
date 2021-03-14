//
//  Date.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation

extension Date {
    static func returnSessionID() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withInternetDateTime
        return dateFormatter.string(from: Date())
    }
}
