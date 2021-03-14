//
//  WatchAvailabilityView.swift
//  Gesture Data Recorder Wearable
//
//  Created by Ranveer M on 7/3/21.
//

import SwiftUI

struct WatchAvailabilityView: View {
    @EnvironmentObject var appWideInformation: AppWideInformation
    var isWatchAvailable: Bool { appWideInformation.isWatchAvailable }
    
    var body: some View {
        Image(systemName: isWatchAvailable ? "applewatch.watchface" : "applewatch")
            .foregroundColor(isWatchAvailable ? .green : .gray)
    }
}

struct WatchAvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        WatchAvailabilityView()
    }
}
