//
//  Dial.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI

struct Dial: View {
    var body: some View {
        ZStack {
            Image("dial1")
            Image("dial2")
            Group {
                Circle()
                    .foregroundStyle(Gradient(stops: [
                        .init(color: .white, location: 0.25),
                        .init(color: Color("gray2"), location: 1.0)
                    ]))
                Circle()
                    .stroke(lineWidth: 6)
                    .foregroundStyle(Color("gray1"))
            }
            .frame(width: 228, height: 228)
        }
    }
}

#Preview {
    Dial()
}
