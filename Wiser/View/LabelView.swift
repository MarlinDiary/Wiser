//
//  LabelView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI
import SwiftData

struct LabelView: View {
    @Query(sort: \Label.name) private var labels: [Label]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 30) {
                                ForEach(labels) { label in
                                    LabelItem(label: .constant(label))
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal)
                        }
                        
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.white.opacity(1),
                                    Color.white.opacity(0.7),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0)
                                ]
                            ),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 30)
                        .allowsHitTesting(false)
                    }
                }
                
                Tip(title: "Label Tip", content: "If you study until 12:30, you will exceed the duration of your study from yesterday morning.")
            }
            .navigationTitle(Text("Label"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Label.self, configurations: config)
    
    // 创建15个示例标签
    let iconTypes: [Icon] = [.dog, .grass, .boxing]
    let labelNames = ["工作", "学习", "运动", "阅读", "游戏", "休息", "旅行", "音乐", "电影", "美食", "购物", "社交", "编程", "设计", "写作"]
    
    for i in 0..<15 {
        let name = labelNames[i]
        let icon = iconTypes[i % iconTypes.count]
        let isActive = i < 12  // 前12个激活，后3个不激活
        let label = Label(name: name, icon: icon, isActive: isActive)
        container.mainContext.insert(label)
    }
    
    return LabelView()
        .modelContainer(container)
}
