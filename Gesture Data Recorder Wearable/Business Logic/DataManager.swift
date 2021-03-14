//
//  DataManager.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 9/3/21.
//

import Foundation
import SwiftUI
import os

struct DataManager {
    var recordingMetadata: RecordingMetadata
    var fileName: String {
        "u\(recordingMetadata.userID)-\(recordingMetadata.activityType.description)-\(recordingMetadata.motionProviderType.rawValue)-data"
    }
    
    func returnSavingAlert(_ data: [String]) -> Alert {
        Alert(
            title: Text("Session Complete"),
            message: Text("Session Complete"),
            primaryButton: .default(
                Text("Save"),
                action: { saveActivityData(data) }
            ),
            secondaryButton: .cancel(Text("Discard"))
        )
    }
    
    private func saveActivityData(_ data: [String]) {
        let dataURL = FileManager.documentDirectoryURL
            .appendingPathComponent(fileName)
            .appendingPathExtension("csv")
        
        do {
            try data.appendLinesToURL(fileURL: dataURL)
            os_log(.debug, log: Log.dataManager, "Data successfully saved to \(fileName).csv")
        } catch {
            os_log(.error, log: Log.dataManager, "Error saving file: \(error.localizedDescription)")
        }
    }
    
    func isUserIdInUse() -> Bool {
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: FileManager.documentDirectoryURL,
                includingPropertiesForKeys: [.isRegularFileKey])
            return files.contains { $0.lastPathComponent.starts(with: fileName) }
        } catch {
            os_log(.error, log: Log.dataManager, "Error reading contents of document folder \(FileManager.documentDirectoryURL): \(error.localizedDescription)")
            return false
        }
    }
    
    func returnUserIDInUseAlert(confirmAction: @escaping () -> (), cancelAction: (() -> Void)? = {}) -> Alert {
        Alert(
            title: Text("User ID Already Exists"),
            message: Text("Data will be added to this user's files. If this is not you, please choose a different ID."),
            primaryButton: .default(
                Text("That's me!"),
                action: confirmAction
            ),
            secondaryButton: .cancel(Text("Change ID"), action: cancelAction)
        )
    }
}
