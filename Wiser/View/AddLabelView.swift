//
//  AddLabelView.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI
import SwiftData

enum FocusField: Hashable {
    case labelName
}

struct AddLabelView: View {
    @Query(sort: \Icon.id) private var icons: [Icon]
    @State private var labelName: String = ""
    @State private var isEditingName: Bool = false
    @FocusState private var focusField: FocusField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 30) {
                    ForEach(icons) { icon in
                        IconAvatarBig(icon: icon)
                    }
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                            TextField("Enter Label Name Here", text: $labelName)
                                .multilineTextAlignment(.center)
                                .frame(width: 200)
                                .submitLabel(.done)
                                .onSubmit {
                                    isEditingName = false
                                }
                                .focused($focusField, equals: .labelName)
                                .bold()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundStyle(.black)
                            .font(.system(size: 15))
                            .rotationEffect(.degrees(45))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 按钮点击动作
                    } label: {
                        Image(systemName: "checkmark")
                            .bold()
                            .foregroundStyle(.black)
                            .font(.system(size: 13))
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Icon.self, configurations: config)
        
        // 创建21个图标，只使用boxing、dog和grass
        for i in 0..<21 {
            let iconType: Icon
            switch i % 3 {
            case 0:
                iconType = .boxing
            case 1:
                iconType = .dog
            default:
                iconType = .grass
            }
            
            let icon = Icon(type: iconType.type, image: iconType.image)
            container.mainContext.insert(icon)
        }
        
        return AddLabelView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
