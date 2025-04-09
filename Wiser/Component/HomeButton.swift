//
//  HomeButton.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI
import SwiftData

struct HomeButton: View {
    @Binding var status: HomeStatus
    @Environment(\.modelContext) private var modelContext
    @Binding var currentLabel: Label?
    
    var body: some View {
        Button {
            switch status {
            case .home:
                // Check in: Create new TimeLog and change status to count
                if let label = currentLabel {
                    let newTimeLog = TimeLog(startTime: Date(), label: label)
                    modelContext.insert(newTimeLog)
                    status = .count
                }
            case .count:
                // Handle check out (will be implemented later)
                status = .home
            case .log:
                // Handle add log (will be implemented later)
                status = .home
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 33)
                    .padding(.horizontal)
                    .frame(height: 67)
                    .foregroundStyle(status == .log ? .orange1 : .black)
                Text(status == .home ? "CHECK IN" : status == .count ? "CHECK OUT" : "ADD LOG")
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
            }
        }
    }
}

#Preview {
    HomeButton(status: .constant(.home), currentLabel: .constant(nil))
}

#Preview {
    HomeButton(status: .constant(.count), currentLabel: .constant(nil))
}

#Preview {
    HomeButton(status: .constant(.log), currentLabel: .constant(nil))
}
