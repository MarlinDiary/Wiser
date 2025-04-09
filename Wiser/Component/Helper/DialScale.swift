//
//  DialScale.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct DialScale: View {
    var status: HomeStatus = .home
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<60) { index in
                Rectangle()
                    .fill(Color("gray2"))
                    .frame(width: 1, height: 5)
                    .offset(y: -106) // radius is 100
                    .rotationEffect(.degrees(Double(index) * 6))
            }
        }
        .onChange(of: status) { oldValue, newValue in
            print("newValue: \(newValue)")
        }
        .rotationEffect(.degrees(rotation))
        .onChange(of: status) { oldValue, newValue in
            if newValue == .count {
                withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            } else {
                withAnimation(.default) {
                    rotation = 0
                }
            }
        }
    }
}

#Preview {
    DialScale()
}

#Preview {
    DialScale(status: .count)
}
