//
//  RockStackView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct RockStackView: View {
    var state: RockState
    @State private var visualState: RockState? = nil
    @State private var isBouncing = false
    @State private var animationDuration: Double = 0.75

    private var displayState: RockState {
        visualState ?? state
    }

    private var bottomPadding: CGFloat {
        0
    }

    private var middlePadding: CGFloat {
        switch displayState {
        case .checked: 111
        case .idle: 40
        case .paused: 79
        }
    }

    private var topPadding: CGFloat {
        switch displayState {
        case .checked: 280
        case .idle: 150
        case .paused: 214
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            RockBottomView(state: displayState)
                .padding(.bottom, bottomPadding)

            RockMiddleView(state: displayState)
                .padding(.bottom, middlePadding)

            RockTopView(state: displayState)
                .padding(.bottom, topPadding)
        }
        .frame(height: 364, alignment: .bottom)
        .animation(.easeInOut(duration: animationDuration), value: displayState)
        .onTapGesture {
            guard state == .idle, !isBouncing else { return }
            isBouncing = true

            let goDown = Double.random(in: 0.55...0.95)
            let hold = Double.random(in: 0.3...0.7)
            let goBack = Double.random(in: 0.55...0.95)
            let target: RockState = Bool.random() ? .paused : .checked

            animationDuration = goDown
            visualState = target
            DispatchQueue.main.asyncAfter(deadline: .now() + goDown + hold) {
                animationDuration = goBack
                visualState = .idle
                DispatchQueue.main.asyncAfter(deadline: .now() + goBack) {
                    visualState = nil
                    isBouncing = false
                }
            }
        }
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
