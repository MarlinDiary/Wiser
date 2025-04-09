//
//  DialContent.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData

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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]), 
                Labels: .constant(sampleLabels), 
                status: .constant(.home))
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]), 
                Labels: .constant(sampleLabels), 
                status: .constant(.log))
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabels = [
        Label(name: "Dog", icon: .dog),
        Label(name: "Grass", icon: .grass),
        Label(name: "Boxing", icon: .boxing)
    ]
    
    for label in sampleLabels {
        container.mainContext.insert(label)
    }
    
    return Dial(currentLabel: .constant(sampleLabels[0]), 
                Labels: .constant(sampleLabels), 
                status: .constant(.count))
        .modelContainer(container)
}
