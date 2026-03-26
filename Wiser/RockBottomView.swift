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
                .resizable()
                .aspectRatio(contentMode: .fit)

            if state == .idle {
                Image("RockBottomShadowIdle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            if state == .paused {
                Image("RockBottomShadowPaused")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
