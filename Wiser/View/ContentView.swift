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
    @State var currentLabel: Label = Label.exampleLabels.first!

    var body: some View {
        VStack {
            HStack {
                LabelIndicator(status: $status, currentLabel: $currentLabel)
                Spacer()
                HomeStatusControl(status: $status)
            }
            .padding(.horizontal)
            
            Spacer()
            Spacer()
            
            Dial(currentLabel: $currentLabel, Labels: .constant(Label.exampleLabels), status: $status)
            
            Spacer()
            Spacer()
            
            HeroTitle(hour: "24", minute: "00")
            
            Spacer()
            
            Heatmap()
            
            Spacer()
            
            HomeButton(status: $status)
        }
    }
}

#Preview {
    ContentView()
}
