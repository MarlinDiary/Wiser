//
//  ContentView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var status: HomeStatus = .home
    @State var currentLabel: Label?
    
    @Query private var labels: [Label]
    
    var body: some View {
        VStack {
            HStack {
                if let currentLabel = currentLabel {
                    LabelIndicator(status: $status, currentLabel: .constant(currentLabel))
                }
                Spacer()
                HomeStatusControl(status: $status)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
            
            if let currentLabel = currentLabel {
                Dial(currentLabel: .constant(currentLabel), Labels: .constant(labels), status: $status)
            }
            
            Spacer()
            Spacer()
            
            HeroTitle(hour: "24", minute: "00")
            
            Spacer()
            
            Heatmap()
            
            Spacer()
            
            HomeButton(status: $status)
        }
        .onAppear {
            if labels.count > 0 && currentLabel == nil {
                currentLabel = labels.first
            }
        }
        .onChange(of: labels) { oldValue, newValue in
            if newValue.count > 0 && currentLabel == nil {
                currentLabel = newValue.first
            }
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
    
    return ContentView()
        .modelContainer(container)
}
