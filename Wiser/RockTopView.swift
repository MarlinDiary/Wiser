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
            .frame(width: 131, height: 84)
            .rotationEffect(.degrees(rotation))
            .brightness(colorScheme == .dark ? 0 : -0.33)
            .animation(.easeInOut(duration: 0.75), value: state)
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
