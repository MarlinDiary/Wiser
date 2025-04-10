//
//  LabelAvatar.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct LabelAvatar: View {
    var label: Label
    
    var body: some View {
            Circle()
            .frame(width: 55.3, height: 55.3)
                .foregroundStyle(.gray2)
                .overlay {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.gray3)
                        .frame(width: 55.3, height: 55.3)
                    
                    Image(label.icon.image)
                        .resizable()
                        .frame(width: 65.35, height: 65.35)
                        .mask {
                            MaskShape()
                                .frame(width: 62, height: 60.32)
                                .offset(x:0, y:-3.5)
                        }
        }
    }
}

struct MaskShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        return Path { path in
            // 按照SVG路径数据创建自定义形状
            path.move(to: CGPoint(x: width * 31.0559815/62, y: height))
            path.addCurve(
                to: CGPoint(x: width * 57.317251/62, y: height * 34.1756757/60.3243243),
                control1: CGPoint(x: width * 45.5596801/62, y: height),
                control2: CGPoint(x: width * 57.317251/62, y: height * 48.6171756/60.3243243)
            )
            path.addCurve(
                to: CGPoint(x: width * 30.933836/62, y: 0),
                control1: CGPoint(x: width * 57.317251/62, y: height * 19.7341758/60.3243243),
                control2: CGPoint(x: width * 78.4484121/62, y: 0)
            )
            path.addCurve(
                to: CGPoint(x: width * 4.79471191/62, y: height * 34.1756757/60.3243243),
                control1: CGPoint(x: width * -16.58074/62, y: 0),
                control2: CGPoint(x: width * 4.79471191/62, y: height * 19.7341758/60.3243243)
            )
            path.addCurve(
                to: CGPoint(x: width * 31.0559815/62, y: height),
                control1: CGPoint(x: width * 4.79471191/62, y: height * 48.6171756/60.3243243),
                control2: CGPoint(x: width * 16.5522828/62, y: height)
            )
            path.closeSubpath()
        }
    }
}

#Preview {
    LabelAvatar(label: Label.exampleLabels[1])
}
