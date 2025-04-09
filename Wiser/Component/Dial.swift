//
//  DialContent.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI

struct Dial: View {
    @Binding var currentLabel: Label
    @Binding var Labels: [Label]
    @Binding var status: HomeStatus
    
    var body: some View {
        TabView {
            ForEach(Labels, id: \.id) { label in
                VStack {
                    if status != .home {
                        HStack(alignment: .lastTextBaseline) {
                            Text("12 : 24")
                                .font(.system(size: 36))
                                .fontWeight(.heavy)
//                            Text("MIN")
//                                .font(.system(size: 9))
//                                .fontWeight(.bold)
                        }
                        .offset(x: 0, y: 46)
                    }
                    
                    Image(label.icon.image)
                        .resizable()
                        .saturation(status == .home ? 0.25 : 1)
                        .frame(width: status == .home ? 228 : 170, height: status == .home ? 228 : 170)
                        .offset(x: 0, y: 25)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: 221, height: 221)
        .clipShape(Circle())
        .overlay {
            DialScale()
        }
        .background {
            DialBackground()
        }
    }
}

#Preview {
    Dial(currentLabel: .constant(Label.exampleLabels.first!), Labels: .constant(Label.exampleLabels), status: .constant(.home))
}

#Preview {
    Dial(currentLabel: .constant(Label.exampleLabels.first!), Labels: .constant(Label.exampleLabels), status: .constant(.log))
}

#Preview {
    Dial(currentLabel: .constant(Label.exampleLabels.first!), Labels: .constant(Label.exampleLabels), status: .constant(.count))
}
