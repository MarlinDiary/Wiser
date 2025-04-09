//
//  WiserApp.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI
import SwiftData

@main
struct WiserApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Label.self,
            Icon.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    loadInitialDataIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func loadInitialDataIfNeeded() {
        Task {
            do {
                let context = sharedModelContainer.mainContext
                
                // 检查是否已有数据
                let existingLabelsCount = try context.fetchCount(FetchDescriptor<Label>())
                
                // 如果没有现有数据，则添加示例数据
                if existingLabelsCount == 0 {
                    // 添加示例标签
                    for exampleLabel in Label.exampleLabels {
                        context.insert(exampleLabel)
                    }
                    
                    try context.save()
                }
            } catch {
                print("加载初始数据时出错: \(error)")
            }
        }
    }
}
