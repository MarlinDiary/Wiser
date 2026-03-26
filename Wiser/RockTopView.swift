//
//  RockTopView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct RockTopView: View {
    @Environment(\.colorScheme) private var colorScheme
    var state: RockState

    private var rotation: Double {
        switch state {
        case .checked: 0
        case .idle: 20
        case .paused: 14
        }
    }

    var body: some View {
        Image("RockTop")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(rotation))
            .brightness(colorScheme == .dark ? 0 : -0.33)
    }
}

#Preview("Checked") {
    RockTopView(state: .checked)
}

#Preview("Idle") {
    RockTopView(state: .idle)
}

#Preview("Paused") {
    RockTopView(state: .paused)
}
