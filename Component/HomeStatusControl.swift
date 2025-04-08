//
//  HomeStatusControl.swift
//  Wiser
//
//  Created by Drawix on 2025/4/8.
//

import SwiftUI

struct HomeStatusControl: View {
    @Binding var status: HomeStatus
    
    var body: some View {
        Group {
            switch status {
            case .home:
                Image(systemName: "plus")
            case .count:
                Image(systemName: "xmark")
            case .log:
                Image(systemName: "power")
            }
        }
        .bold()
    }
}

#Preview {
    HomeStatusControl(status: .constant(.home))
}

#Preview {
    HomeStatusControl(status: .constant(.count))
}

#Preview {
    HomeStatusControl(status: .constant(.log))
}
