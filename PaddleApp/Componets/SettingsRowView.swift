//
//  SettingsRowView.swift
//  PaddleApp
//
//  Created by Jack Chambers on 2025-01-18.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color(.black))
        }
    }
}

#Preview {
    SettingsRowView(imageName: "Gear", title: "Version", tintColor: Color(.systemGray))
}
