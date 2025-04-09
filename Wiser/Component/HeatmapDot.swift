//
//  HeatmapDot.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct HeatmapDot: View {
    @State private var isAnimating = false
    var status: HeatmapDotStatus = .blank
    var body: some View {
        Group {
            switch status {
            case .blank:
                Circle()
                
            case .now:
                Circle()
                    .overlay(
                        Circle()
                            .stroke(Color("orange1"), lineWidth: isAnimating ? 1.2 : 0.6)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                    )
                    .onAppear {
                        isAnimating = true
                    }
                
            case .record:
                Circle()
                    .foregroundStyle(.black)
            case .select:
                Circle()
                    .foregroundStyle(.orange1)
            }
        }
        .frame(width: 9, height: 9)
        .foregroundStyle(Color("gray3"))
    }
}

enum HeatmapDotStatus {
    case blank
    case record
    case select
    case now
}

#Preview {
    HeatmapDot(status: .blank)
}

#Preview {
    HeatmapDot(status: .now)
}

#Preview {
    HeatmapDot(status: .record)
}

#Preview {
    HeatmapDot(status: .select)
}
