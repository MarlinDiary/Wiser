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
                    .foregroundStyle(Color("gray3"))
                
            case .now:
                Circle()
                    .foregroundStyle(Color("gray3"))
                    .overlay(
                        Circle()
                            .stroke(Color("orange1"), lineWidth: isAnimating ? 1 : 0.6)
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
                    .foregroundStyle(Color("orange1"))
            case .nowWithRecord:
                Circle()
                    .foregroundStyle(.black)
                    .overlay(
                        Circle()
                            .stroke(Color("orange1"), lineWidth: isAnimating ? 1 : 0.6)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                    )
                    .onAppear {
                        isAnimating = true
                    }
            }
        }
        .frame(width: 9, height: 9)
    }
}

enum HeatmapDotStatus {
    case blank
    case record
    case select
    case now
    case nowWithRecord
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

#Preview {
    HeatmapDot(status: .nowWithRecord)
}
