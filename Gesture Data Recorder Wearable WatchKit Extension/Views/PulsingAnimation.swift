//
//  PulsingCricleView.swift
//  Gesture Data Recorder Wearable WatchKit Extension
//
//  Created by Ranveer M on 9/3/21.
//

import SwiftUI

struct PulsingCricleView: View {
    @State private var animate = false
    var color: Color = .green
    
    var body: some View {
        ZStack {
            Group {
                PulsingCircle(radius: 120)
                PulsingCircle(radius: 100)
            }.scaleEffect(animate ? 1 : 0.60)
            PulsingCircle(radius: 80)
        }
        .onAppear { self.animate.toggle() }
        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
    }
    
    private struct PulsingCircle: View {
        var radius: CGFloat
        var color: Color = .green
        
        var body: some View {
            Circle()
                .fill(color.opacity(0.25))
                .frame(width: radius, height: radius)
        }
    }
}

struct PulsingCricleView_Previews: PreviewProvider {
    static var previews: some View {
        PulsingCricleView()
    }
}
