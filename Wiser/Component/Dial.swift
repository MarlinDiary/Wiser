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
    @Binding var status: HomeStatus
    var labels: [Label]
    
    var body: some View {
        TabView(selection: Binding(
            get: { currentLabel.id },
            set: { newValue in
                if let index = labels.firstIndex(where: { $0.id == newValue }) {
                    currentLabel = labels[index]
                }
            }
        )) {
            ForEach(labels, id: \.id) { label in
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
                .tag(label.id)
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
                status: .constant(.home),
                labels: sampleLabels )
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
                status: .constant(.log),
                labels: sampleLabels )
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
                status: .constant(.count),
                labels: sampleLabels )
        .modelContainer(container)
}
