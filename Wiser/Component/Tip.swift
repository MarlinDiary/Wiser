//
//  Tip.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct Tip: View {
    var title: String
    var content: String
    var body: some View {
        VStack {
            Divider()
                .padding(.bottom, 36)
            Text(title)
                .bold()
                .font(.system(size: 15))
                .padding(.bottom, 18)
            Text(content)
                .lineSpacing(9)
                .font(.system(size: 13))
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray4)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Tip(title: "Focus Tip", content: "If you study until 12:30, you will exceed the duration of your study from yesterday morning.")
}
