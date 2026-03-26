//
//  ContentView.swift
//  Wiser
//
//  Created by Marlin on 26/03/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    var backgroundColor: Color {
        Color(.secondarySystemBackground)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            Image("NoiseTexture")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
                .opacity(colorScheme == .dark ? 0.05 : 1)
            VStack {
                Spacer()
                RockStackView(state: .idle)
                    .scaleEffect(0.5)
                    .frame(height: 364 * 0.5)
                Spacer()
                Button(action: {
                    // TODO
                }) {
                    Label("Start Focus", systemImage: "play.fill")
                        .font(.headline)
                        .padding(8)
                }
                .buttonStyle(.glass)
            }
        }
    }
}

#Preview {
    ContentView()
}
