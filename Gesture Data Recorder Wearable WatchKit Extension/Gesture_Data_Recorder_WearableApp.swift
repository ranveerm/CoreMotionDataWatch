//
//  Gesture_Data_Recorder_WearableApp.swift
//  Gesture Data Recorder Wearable WatchKit Extension
//
//  Created by Ranveer M on 4/3/21.
//

import SwiftUI

@main
struct Gesture_Data_Recorder_WearableApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
