//
//  LabelItem.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct LabelItem: View {
    @Binding var label: Label
    
    var body: some View {
        VStack {
            LabelAvatarBig(label: label)
                .saturation(label.isActive ? 1 : 0)
            Text(label.name)
                .foregroundStyle(.gray5)
                .fontWeight(.medium)
                .font(.system(size: 13))
        }
        .opacity(label.isActive ? 1 : 0.5)
    }
}

#Preview {
    LabelItem(label: .constant(Label.exampleLabels[1]))
}

#Preview {
    LabelItem(label: .constant(Label.exampleLabels[2]))
}
