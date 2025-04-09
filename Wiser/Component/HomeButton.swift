//
//  HomeButton.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct HomeButton: View {
    @Binding var status: HomeStatus
    
    var body: some View {
        Button {
            
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
    HomeButton(status: .constant(.home))
}

#Preview {
    HomeButton(status: .constant(.count))
}

#Preview {
    HomeButton(status: .constant(.log))
}
