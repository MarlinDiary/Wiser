//
//  DialScale.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct DialScale: View {
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
    }
}

#Preview {
    DialScale()
}
