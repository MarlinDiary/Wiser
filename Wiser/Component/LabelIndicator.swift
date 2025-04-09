//
//  LabelIndicator.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI

struct LabelIndicator: View {
    @Binding var status: HomeStatus
    @Binding var currentLabel: Label
    
    var body: some View {
        HStack{
            Circle()
                .strokeBorder(Color.black.opacity(0.25), lineWidth: 0.2)
                .background(
                    Circle()
                        .fill(status == .home ? Color("gray3") : (status == .log ? Color("orange1"): Color("green1")))
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.25), lineWidth: 1)
                                .blur(radius: 1)
                        )
                        .mask(Circle())
                )
                .shadow(color: status == .home ? Color("gray3").opacity(0) : (status == .log ? Color("orange1"): Color("green1")), radius: 2)
                .frame(width: 12, height: 12)
            
            Text(currentLabel.name)
                .bold()
            
            if status == .home {
                Image(systemName: "chevron.down")
                    .bold()
                    .font(.system(size: 12))
            }
        }
    }
}

#Preview {
    LabelIndicator(status: .constant(.home), currentLabel: .constant(Label.exampleLabels.first!))
}

#Preview {
    LabelIndicator(status: .constant(.log), currentLabel: .constant(Label.exampleLabels.first!))
}

#Preview {
    LabelIndicator(status: .constant(.count), currentLabel: .constant(Label.exampleLabels.first!))
}
