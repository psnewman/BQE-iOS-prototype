//
//  HomeSection.swift
//  BQE
//
//  Created by Paul Newman on 11/10/24.
//
//

import FASwiftUI
import SwiftUI

struct HomeSectionView<Content: View>: View {
  let label: String
  let id: String
  let content: Content
  @State private var isExpanded: Bool = true
  
  init(label: String, id: String, @ViewBuilder content: () -> Content) {
    self.label = label
    self.id = id
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      HomeSectionLabel(label: label, isExpanded: isExpanded)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
          isExpanded.toggle()
        }

      if isExpanded {
        content
      }

      Divider()
        .background(.divider)
    }
    .padding(.horizontal, 16)
    .scrollClipDisabled()
    .id(id)
  }
}

struct HomeSectionLabel: View {
  let label: String
  var isExpanded: Bool

  var body: some View {
    HStack {
      FAText(iconName: "chevron-right", size: 12)
        .foregroundColor(.typographySecondary)
        .rotationEffect(.degrees(isExpanded ? 90 : 0))
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
      Text(label.uppercased())
        .bodySmallBoldStyle()
        .foregroundStyle(.typographyPrimary)
    }
    .padding(.top, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  init(label: String, isExpanded: Bool) {
    self.label = label
    self.isExpanded = isExpanded
  }
}

#Preview {
  VStack {
    HomeSectionView(label: "Test Section", id: "test-section") {
      MyTimersSectionView()
    }
  }
}
