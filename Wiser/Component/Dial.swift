//
//  DialContent.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI

struct Dial: View {
    @Binding var currentLabel: String
    @Binding var Labels: [Label]
    
    var body: some View {
        TabView {
            ForEach(Labels, id: \.id) { label in
                Image(label.icon.image)
                    .frame(width: 228, height: 228)
                    .offset(x: 0, y: 25)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: 215, height: 215)
        .clipShape(Circle())
        .background {
            DialBackground()
        }
    }
}

#Preview {
    Dial(currentLabel: .constant("React"), Labels: .constant(Label.exampleLabels))
}
