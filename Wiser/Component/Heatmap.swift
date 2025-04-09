//
//  Heatmap.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct Heatmap: View {
    @State private var heatmapData: [[HeatmapDotStatus]] = Array(
            repeating: Array(repeating: .blank, count: 12),
            count: 24
        )
    
    var body: some View {
            HStack(spacing: 6) {
                ForEach(0..<24, id: \.self) { column in
                    VStack(spacing: 6) {
                        Text(String(format: "%02d", column))
                            .font(.system(size: 7))
                            .foregroundStyle(.secondary)
                        
                        ForEach(0..<12, id: \.self) { row in
                            HeatmapDot(status: heatmapData[column][row])
                        }
                    }
                }
            }
    }
}

#Preview {
    Heatmap()
}
