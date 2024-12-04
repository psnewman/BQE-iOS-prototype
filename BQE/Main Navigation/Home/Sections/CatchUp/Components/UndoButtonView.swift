//
//  UndoButtonView.swift
//  BQE
//
//  Created by Paul Newman on 12/4/24.
//

import FASwiftUI
import SwiftUI

struct UndoButtonView: View {
  let counter: Int

  var body: some View {
    HStack(spacing: 8) {
      HStack(spacing: 4) {
        FAText(iconName: "arrow-rotate-left", size: 12)
          .foregroundColor(.masterPrimary)

        Text("Undo")
          .bodySmallStyle()
          .foregroundColor(.masterPrimary)
      }
      ZStack {
        Circle()
          .fill(.white)
          .stroke(.masterPrimary, lineWidth: 1)
          .frame(width: 16, height: 16)
        Text("\(counter)")
          .bodySmallStyle()
          .foregroundColor(.masterPrimary)
      }
    }
    .frame(minHeight: 24)
    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 4))
    .background(Color.masterPrimary.opacity(0.1))
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.masterPrimary, lineWidth: 1))
    .cornerRadius(20)
  }
}

#Preview {
  UndoButtonView(counter: 0)
}
