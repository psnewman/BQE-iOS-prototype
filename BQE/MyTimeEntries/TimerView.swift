//
//  TimerView.swift
//  BQE
//
//  Created by Paul Newman on 6/4/25.
//

import FASwiftUI
import SwiftUI

struct TimerView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      VStack(alignment: .leading, spacing: 4) {
        Text("Design: 3D Modeling")
          .bodyBoldStyle()
          .foregroundColor(.typographyPrimary)
        HStack(spacing: 4) {
          Text("19-34 - Aspen Cultural Center")
            .bodySmallStyle()
            .foregroundColor(.typographyPrimary)
          Text("/")
            .bodySmallStyle()
            .foregroundColor(.typographyPrimary)
          Text("Schematic Design")
            .bodySmallStyle()
            .foregroundColor(.typographyPrimary)
        }
      }
    }
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.yellow, lineWidth: 1)
    )
  }
}

#Preview {
  TimerView()
}
