//
//  ContentView.swift
//  Gesture Data Recorder Wearable WatchKit Extension
//
//  Created by Ranveer M on 4/3/21.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject var phoneConnectivityProvider = PhoneConnectivityProvider()
    
    var body: some View {
        phoneConnectivityProvider.recordingState.returnView()
    }
}

extension RecordingState {
    func returnView() -> some View {
        let activationState = (WCSession.default.activationState == .activated)
        switch self {
        case .isRecording:
            return AnyView(PulsingCricleView())
        default:
            return AnyView(
                Text(activationState  ? "Ready to record" : "Unavailable")
                .foregroundColor(activationState ? Color.green : Color.gray)
                .padding()
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
