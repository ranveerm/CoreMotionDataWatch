//
//  Gesture_Data_Recorder_WearableApp.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 4/3/21.
//

import SwiftUI

@main
struct Gesture_Data_Recorder_WearableApp: App {
    @ObservedObject var appWideInformation: AppWideInformation
    @ObservedObject var contentViewModel: ContentViewModel
//    @ObservedObject var watchConnectivityProvider = WatchConnectivityProvider()
    
    init() {
        let appWideInformation = AppWideInformation()
        self.appWideInformation = appWideInformation
        self.contentViewModel = ContentViewModel(dataRecorder: appWideInformation.dataRecorder)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appWideInformation)
                .environmentObject(contentViewModel)
        }
    }
}
