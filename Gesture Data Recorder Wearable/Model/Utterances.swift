//
//  Utterances.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 4/3/21.
//

import Foundation
import AVFoundation

// Utterances enum stores all the phrases the app speaks
enum Utterances {
    static let phonePlacement = AVSpeechUtterance(string: "Please hold your phone in your right hand, with the home button at the bottom. The screen should be facing out, so you can see it, not facing toward your hand.")
    static let watchPlacement = AVSpeechUtterance(string: "Please hold the hand with your watch outstreatched in front of you.")
    static let sessionStart = AVSpeechUtterance(string: "The session will begin in 5...4...3...2...1...")
    static let driveIt = AVSpeechUtterance(string: "Position the phone out in front of you, with your wrist turned so the phone's screen is facing the ground. When the countdown ends, please begin rocking the phone back and forth, as if you are pretending to drive a car while trying to look cool.")
    static let shakeIt = AVSpeechUtterance(string: "Position the phone vertically, with the screen facing to your left.... Hold it firmly, and when the countdown ends, shake the phone vigorously in short bursts.")
    static let chopIt = AVSpeechUtterance(string: "Position the phone vertically, with the screen facing to your left.... When the countdown ends, please begin making a steady chopping motion by bending your arm at your elbow. Be sure your wrist is bent so you are chopping with the phone, not stabbing.")
    
    static let begin = AVSpeechUtterance(string: "Begin in 3...2...1.")
    static let sessionComplete = AVSpeechUtterance(string: "This recording session is now complete.")
    static let error = AVSpeechUtterance(string: "An error has occurred.")
    
    static let twenty = AVSpeechUtterance(string: "20")
    static let fifteen = AVSpeechUtterance(string: "15")
    static let ten = AVSpeechUtterance(string: "10")
    static let nine = AVSpeechUtterance(string: "9")
    static let eight = AVSpeechUtterance(string: "8")
    static let seven = AVSpeechUtterance(string: "7")
    static let six = AVSpeechUtterance(string: "6")
    static let five = AVSpeechUtterance(string: "5")
    static let four = AVSpeechUtterance(string: "4")
    static let three = AVSpeechUtterance(string: "3")
    static let two = AVSpeechUtterance(string: "2")
    static let one = AVSpeechUtterance(string: "1")
    static let stop = AVSpeechUtterance(string: "And stop.")
    static let rest = AVSpeechUtterance(string: "Now rest for a few seconds.")
    static let ok = AVSpeechUtterance(string: "Ok, I hope you're ready.")
    static let again = AVSpeechUtterance(string: "When the countdown ends, please perform the same activity as before.")
    
    static func randomRestTimeCountDown() -> AVSpeechUtterance {
        // choose a random amount of time to rest just to keep life interesting
        switch Int.random(in: 1...3) {
        case 1: return Utterances.five
        case 2: return Utterances.six
        default: return Utterances.four
        }
    }
    
    static func randomRecordTimeCountdown() -> AVSpeechUtterance {
        // choose a random amount of time to perform activity to mix up the data
        switch Int.random(in: 1...2) {
        case 1: return Utterances.fifteen
        default: return Utterances.twenty
        }
    }
    
    static func devicePlacement(_ motionProviderType: MotionProviderType?) -> AVSpeechUtterance {
        switch motionProviderType {
        case .phone: return Utterances.phonePlacement
        case .watch: return Utterances.watchPlacement
        case .none: return Utterances.error
        }
    }
}
