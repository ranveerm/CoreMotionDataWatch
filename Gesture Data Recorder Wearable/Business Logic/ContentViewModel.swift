//
//  ContentViewModel.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import SwiftUI
import CoreMotion
import Combine
import WatchConnectivity

class ContentViewModel: ViewModel {
    /**
     Set to an optional value to ensure- 1) an external module can not modify metadata (which wiill be required if it is initialised with irrelevant metadata at the start. An alternative approach will be to make the metadata property optional) and 2) can be implemented as a struct while  avoiding mutating functiions

     - Version: 1.0
     - Author: Ranveer M 👨🏾‍💻
    */
    var dataManager: DataManager?
    var dataRecorder: DataRecorder
    var audioCueManagerBasic: AudioCueManager = AudioCueManagerBasic()
    
    var alert = Alert(title: Text(""))
    
    init(dataRecorder: DataRecorder, dataManager: DataManager? = nil) {
        self.dataManager = dataManager
        self.dataRecorder = dataRecorder
        
        audioCueManagerBasic.sessionStartHandler = { sessionStartType in
            switch sessionStartType {
            case .instructions: self.queueNextActivity()
            case .recordinig: self.trigger(.isRecording)
            }
        }
        audioCueManagerBasic.sessionStopHandler = { self.trigger(.finishedRecording) }
    }
    
    // MARK: - ViewModel Conformance
    @Published private(set) var state: RecordingState = .isNotRecording
    
    func trigger(_ input: RecordingState) {
        state = input
        switch input {
        case .prepareToRecord(let recordingMetadata): prepareToRecord(recordingMetadata: recordingMetadata)
        case .isRecording: initiateRecording()
        case .finishedRecording: finishedRecording()
        case .isNotRecording:
            state = .isNotRecording
        case .unableToRecord(let message):
            handleUnableToRecord(message)
        }
    }
    
    // MARK: - View specific properties
    @Published var showAlert = false
}

// MARK: - State change actions
extension ContentViewModel {
    /**
     Actions undertaken before recordiing beings
     
     `dataManager` initialised here because this is where metadata for recoding is available.

     - Important: Trigger to enter into recording `isRecording` state performed by `audioCueManagerBasic` delegate after uttering `devicePlacement` by invoking `sessionStartHandler()` (set in initialiser above)
     - Version: 1.0
     - Author: Ranveer M 👨🏾‍💻
    */
    func prepareToRecord(recordingMetadata: RecordingMetadata) {
        // Error conditions
        if !dataRecorder.isMotionProviderAvailable {
            self.trigger(.unableToRecord(message: "Device motion data is unavailable"))
        }
        dataManager = DataManager(recordingMetadata: recordingMetadata)
        dataRecorder.initialiseActionsToRecord(recordingMetadata.numberOfActivitySessionsToRecord)
        
        // Below avoids force unwrapping
        guard let dataManager = dataManager else { return }
        
        state = .prepareToRecord(recordingMetadata: recordingMetadata)
        
        if dataManager.isUserIdInUse() {
            alert = dataManager.returnUserIDInUseAlert(confirmAction: { self.audioCueManagerBasic.synth.speak(Utterances.devicePlacement(self.dataRecorder.deviceMotionProvider?.motionProviderType)) },
                                                       cancelAction: { self.trigger(.isNotRecording) })
            showAlert = true
        } else {
            self.audioCueManagerBasic.synth.speak(Utterances.devicePlacement(self.dataRecorder.deviceMotionProvider?.motionProviderType))
        }
    }
    
    func initiateRecording() {
        state = .isRecording
        dataRecorder.deviceMotionProvider?.recordMotionUpdates() { data in
            self.dataRecorder.activityData.append(self.dataManager?.recordingMetadata.enrichData(data) ?? data)
        }
    }
    
    func handleUnableToRecord(_ message: String) {
        self.state = .unableToRecord(message: message)
        DispatchQueue.main.async {
            self.alert = Alert(title: Text("Unable to Record"), message: Text(message), dismissButton: .default(Text("Got it!")))
            self.showAlert = true
        }
        dataManager = nil
        trigger(.isNotRecording)
    }
    
    func finishedRecording() {
        state = .finishedRecording
        dataRecorder.deviceMotionProvider?.stopMotionUpdates()
        
        if checkIfFinishedRecording() {
            audioCueManagerBasic.synth.speak(Utterances.sessionComplete)
            
            guard let savingAlert = dataManager?.returnSavingAlert(dataRecorder.activityData) else {
                self.trigger(.isNotRecording)
                return
            }
            
            alert = savingAlert
            DispatchQueue.main.async { self.showAlert = true }
            
            self.trigger(.isNotRecording)
        } else {
            audioCueManagerBasic.isResting = true
            
            // Resting workflow automatically triggers `isRecording` via `sessionStartHandler`
            audioCueManagerBasic.synth.speak(Utterances.rest)
        }
    }
}

// MARK: - Helper methods
extension ContentViewModel {
    func queueNextActivity() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.dataRecorder.incrementNumberOfActionsRecorded()
            // TODO: Implement randomised activities
//            self.currendActivity = selectedActivity
            if self.dataRecorder.numberOfActionsRecorded > 1 {
                self.audioCueManagerBasic.synth.speak(Utterances.again)
            } else {
                self.audioCueManagerBasic.synth.speak(self.dataManager?.recordingMetadata.activityType.utterance() ?? Utterances.error)
            }
        }
    }
    
    func checkIfFinishedRecording() -> Bool {
        dataRecorder.numberOfActionsRecorded >= dataRecorder.numberOfActionsToRecord
    }
    
    func showRequestToLaunchWatchApp() {
        self.alert =  Alert(title: Text("Launch the app on your Apple Watch"), message:
                                Text("In order to use your watch to record motion data, ensure the counterpart App on your Apple Watch is installed and launched."), dismissButton: .default(Text("Got it!")))
        self.showAlert = true
    }
}
