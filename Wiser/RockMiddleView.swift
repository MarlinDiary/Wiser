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
                .resizable()
                .aspectRatio(contentMode: .fit)

            if state == .idle {
                Image("RockMiddleShadowIdle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            if state == .paused {
                Image("RockMiddleShadowPaused")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .rotationEffect(.degrees(state == .paused ? -9 : 0))
        .brightness(colorScheme == .dark ? 0 : -0.33)
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
