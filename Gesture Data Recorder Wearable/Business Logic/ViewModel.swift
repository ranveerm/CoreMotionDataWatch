//
//  ViewModel.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 5/3/21.
//

import Foundation
import Combine
import CoreMotion
import SwiftUI
import AVFoundation

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input
    
    var state: State { get }
    func trigger(_ input: Input)
}

final class AnyViewModel<State, Input>: ObservableObject {
    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedState: () -> State
    private let wrappedTrigger: (Input) -> Void
    
    var objectWillChange: some Publisher {
        wrappedObjectWillChange()
    }
    
    var state: State {
        wrappedState()
    }
    
    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }
    
    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
    }
}
