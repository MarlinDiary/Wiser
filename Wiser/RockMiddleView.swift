//
//  RockMiddleView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct RockMiddleView: View {
    @Environment(\.colorScheme) private var colorScheme
    var state: RockState

    var body: some View {
        ZStack {
            Image("RockMiddle")
                .frame(width: 294, height: 136)

            Image("RockMiddleShadowIdle")
                .frame(width: 294, height: 136)
                .opacity(state == .idle ? 1 : 0)

            Image("RockMiddleShadowPaused")
                .frame(width: 294, height: 136)
                .opacity(state == .paused ? 1 : 0)
        }
        .rotationEffect(.degrees(state == .paused ? -9 : 0))
        .brightness(colorScheme == .dark ? 0 : -0.33)
        .animation(.easeInOut(duration: 0.75), value: state)
    }
}

#Preview("Checked") {
    RockMiddleView(state: .checked)
}

#Preview("Idle") {
    RockMiddleView(state: .idle)
}

#Preview("Paused") {
    RockMiddleView(state: .paused)
}
