//
//  HeroTitle.swift
//  Wiser
//
//  Created by Drawix on 2025/4/9.
//

import SwiftUI

struct HeroTitle: View {
    var status: HeroTitleStatus = .normal
    var hour: String = "09"
    var minute: String = "05"
    var title: String = ""
    
    init(hour: String, minute: String) {
        self.status = .time
        self.hour = hour
        self.minute = minute
    }
    
    init (title: String) {
        self.status = .normal
        self.title = title
    }
    
    var body: some View {
        Group {
            switch status {
            case .time:
                HStack(alignment: .firstTextBaseline) {
                    Text(hour)
                    Text("HOUR")
                        .font(.system(size: 20))
                    Text(minute)
                    Text("MIN")
                        .font(.system(size: 20))
                }
            case .normal:
                Text(title)
            }
        }
        .font(.system(size: 36))
        .fontWeight(.bold)
    }
}

enum HeroTitleStatus {
    case time
    case normal
}

#Preview {
    HeroTitle(title: "Hello")
}

#Preview {
    HeroTitle(hour: "09", minute: "05")
}
