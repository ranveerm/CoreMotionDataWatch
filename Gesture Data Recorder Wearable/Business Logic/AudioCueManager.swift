//
//  DataRecorder.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import Foundation
import SwiftUI
import AVFoundation
import CoreMotion
import WatchConnectivity
import os

protocol AudioCueManager: AVSpeechSynthesizerDelegate {
    var synth: AVSpeechSynthesizer { get }
    var sessionStartHandler: ((SessionStartType) -> ())? { get set }
    var sessionStopHandler: (() -> ())? { get set }
    
    var isResting: Bool { get set }
}

enum SessionStartType {
    case instructions, recordinig
}

class AudioCueManagerBasic: NSObject, AVSpeechSynthesizerDelegate, AudioCueManager {
    var synth = AVSpeechSynthesizer()
    var sessionStartHandler: ((SessionStartType) -> ())?
    var sessionStopHandler: (() -> ())?
    
    override init() {
        super.init()
        synth.delegate = self
    }
    
    var isResting = false
}

extension AudioCueManagerBasic {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        switch utterance {
        case Utterances.phonePlacement, Utterances.watchPlacement:
            synth.speak(Utterances.sessionStart, after: Config.secondsBetweenSetupInstructions)
        case Utterances.sessionStart: sessionStartHandler?(.instructions)
            
        case Utterances.driveIt, Utterances.shakeIt, Utterances.chopIt:
            synth.speak(Utterances.begin, after: Config.countdownPace)
            
        case Utterances.begin:
            synth.speak(Utterances.randomRecordTimeCountdown(), after: Config.countdownPace)
            DispatchQueue.main.asyncAfter(deadline: .now() + Config.countdownPace) {
                self.sessionStartHandler?(.recordinig)
            }
            
        case Utterances.twenty:
            synth.speak(Utterances.fifteen, after: Config.countdownSkip5)
        case Utterances.fifteen:
            synth.speak(Utterances.ten, after: Config.countdownSkip5)
        case Utterances.ten:
            synth.speak(Utterances.nine, after: Config.countdownPace)
        case Utterances.nine:
            synth.speak(Utterances.eight, after: Config.countdownPace)
        case Utterances.eight:
            synth.speak(Utterances.seven, after: Config.countdownPace)
        case Utterances.seven:
            synth.speak(Utterances.six, after: Config.countdownPace)
        case Utterances.six:
            synth.speak(Utterances.five, after: Config.countdownPace)
        case Utterances.five:
            synth.speak(Utterances.four, after: Config.countdownPace)
        case Utterances.four:
            synth.speak(Utterances.three, after: Config.countdownPace)
        case Utterances.three:
            synth.speak(Utterances.two, after: Config.countdownPace)
        case Utterances.two:
            synth.speak(Utterances.one, after: Config.countdownPace)
        case Utterances.one:
            if isResting {
                isResting = false
                synth.speak(Utterances.ok, after: Config.secondsBetweenSetupInstructions)
            }
            else { synth.speak(Utterances.stop, after: Config.countdownPace) }
        case Utterances.stop: sessionStopHandler?()
            
        case Utterances.rest:
            synth.speak(Utterances.randomRestTimeCountDown(), after: Config.countdownPace)
        case Utterances.again:
            synth.speak(Utterances.begin, after: Config.secondsBetweenSetupInstructions)
        case Utterances.ok:
            synth.speak(Utterances.sessionStart, after: Config.countdownPace)
            
        case Utterances.sessionComplete: return
        default:
            // This should never happen, but can be useful for debugging if you
            // add a new utterance and forget to handle it above.
            os_log(.error, log: Log.audioManager, "Unhandled utterance: \(utterance).")
        }
    }
}
