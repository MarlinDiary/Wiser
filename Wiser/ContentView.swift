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
        colorScheme == .dark
            ? Color(red: 0x54/255.0, green: 0x54/255.0, blue: 0x5C/255.0)
            : Color(red: 0xEC/255.0, green: 0xEE/255.0, blue: 0xEE/255.0)
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            Image("NoiseTexture")
                .resizable(resizingMode: .tile)
                .ignoresSafeArea()
                .opacity(colorScheme == .dark ? 0.05 : 1)
            RockStackView(state: .idle)
                .scaleEffect(0.5)
                .frame(height: 364 * 0.5)
        }
    }
}

#Preview {
    ContentView()
}
