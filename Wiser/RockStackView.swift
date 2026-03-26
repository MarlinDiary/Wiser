//
//  RockStackView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct RockStackView: View {
    var state: RockState

    private var bottomPadding: CGFloat {
        0
    }

    private var middlePadding: CGFloat {
        switch state {
        case .checked: 111
        case .idle: 40
        case .paused: 79
        }
    }

    private var topPadding: CGFloat {
        switch state {
        case .checked: 280
        case .idle: 150
        case .paused: 214
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            RockBottomView(state: state)
                .padding(.bottom, bottomPadding)

            RockMiddleView(state: state)
                .padding(.bottom, middlePadding)

            RockTopView(state: state)
                .padding(.bottom, topPadding)
        }
        .frame(height: 364, alignment: .bottom)
        .animation(.easeInOut(duration: 0.75), value: state)
    }
}

#Preview("Checked") {
    RockStackView(state: .checked)
}

#Preview("Idle") {
    RockStackView(state: .idle)
}

#Preview("Paused") {
    RockStackView(state: .paused)
}
