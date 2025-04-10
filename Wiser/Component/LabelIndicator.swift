//
//  LabelIndicator.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData

struct LabelIndicator: View {
    @Binding var status: HomeStatus
    var currentLabel: Label
    
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
                .font(.system(size: 17))
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabel = Label(name: "Dog", icon: .dog)
    container.mainContext.insert(sampleLabel)
    
    return LabelIndicator(status: .constant(.home), currentLabel: sampleLabel)
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabel = Label(name: "Dog", icon: .dog)
    container.mainContext.insert(sampleLabel)
    
    return LabelIndicator(status: .constant(.log), currentLabel: sampleLabel)
        .modelContainer(container)
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    let sampleLabel = Label(name: "Dog", icon: .dog)
    container.mainContext.insert(sampleLabel)
    
    return LabelIndicator(status: .constant(.count), currentLabel: sampleLabel)
        .modelContainer(container)
}
