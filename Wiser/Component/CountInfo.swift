//
//  CountInfo.swift
//  Wiser
//
//  Created by Drawix on 2025/4/10.
//

import SwiftUI

struct CountInfo: View {
    var logo: String
    var name: String
    var number: String
    var unit: String
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 35, height: 35)
                    .foregroundStyle(.gray3)
                Image(systemName: logo)
                    .foregroundStyle(.gray4)
                    .font(.system(size: 20))
            }
            Text(name)
                .foregroundStyle(.gray4)
            
            Spacer()
            
            Text(number)
                .bold()
            
            Text(unit)
                .font(.system(size: 9))
                .bold()
        }
        .font(.system(size: 17))
        .padding(.horizontal)
    }
}

#Preview {
    CountInfo(logo:"clock", name:"Start time", number:"08:30", unit:"AM")
}
