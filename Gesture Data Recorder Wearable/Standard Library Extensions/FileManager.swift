//
//  FileManager.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 5/3/21.
//

import Foundation

extension FileManager {
    // convenience function to get proper directoy to store data recordings
    static var documentDirectoryURL: URL {
        try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
