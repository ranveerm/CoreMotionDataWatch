//
//  Array.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 5/3/21.
//

import Foundation

// extension to simplify writing String arrays to file
extension Array where Element == String {
    func appendLinesToURL(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self.toData())
        } else if !FileManager.default.createFile(atPath: fileURL.path, contents: toData()) {
            print("ERROR: data could not be saved to \(fileURL.path)")
        }
    }
    
    func toData() -> Data {
        map { $0 + "\n" }
            .joined(separator: "")
            .data(using: .utf8) ?? Data()
    }
}
