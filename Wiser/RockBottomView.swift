//
//  RockBottomView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct RockBottomView: View {
    @Environment(\.colorScheme) private var colorScheme
    var state: RockState

    var body: some View {
        ZStack {
            Image("RockBottom")
                .frame(width: 180, height: 91)

            if state == .idle {
                Image("RockBottomShadowIdle")
                    .frame(width: 180, height: 91)
            }

            if state == .paused {
                Image("RockBottomShadowPaused")
                    .frame(width: 180, height: 91)
            }
        }
        .brightness(colorScheme == .dark ? 0 : -0.33)
    }
}

#Preview("Checked") {
    RockBottomView(state: .checked)
}

#Preview("Idle") {
    RockBottomView(state: .idle)
}

#Preview("Paused") {
    RockBottomView(state: .paused)
}
