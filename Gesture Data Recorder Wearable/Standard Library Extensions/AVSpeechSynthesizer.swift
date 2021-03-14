//
//  AVSpeechSynthesizer.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 5/3/21.
//

import Foundation
import AVFoundation

// extension to allow scheduling utterances on the main thread
extension AVSpeechSynthesizer {
    func speak(_ utterance: AVSpeechUtterance, after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) { [weak self] in
            guard let self = self else { return }
            self.speak(utterance)
        }
    }
}
