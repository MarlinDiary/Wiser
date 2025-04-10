//
//  LabelAvatar.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct LabelAvatarBig: View {
    var label: Label
    
    var body: some View {
            Circle()
            .frame(width: 66, height: 66)
                .foregroundStyle(.gray2)
                .overlay {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.gray3)
                        .frame(width: 66, height: 66)
                    
                    Image(label.icon.image)
                        .resizable()
                        .frame(width: 78, height: 78)
                        .mask {
                            MaskShape()
                                .frame(width: 74, height: 72)
                                .offset(x:0, y:-4)
                        }
        }
    }
}

#Preview {
    LabelAvatarBig(label: Label.exampleLabels[1])
}
