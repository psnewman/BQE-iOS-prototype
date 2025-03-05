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
  let content: Content
  let showViewAll: Bool
  let isLastSection: Bool
  @Binding var isExpanded: Bool

  init(
    _ label: String,
    isExpanded: Binding<Bool>,
    showViewAll: Bool = false,
    isLastSection: Bool = false,
    @ViewBuilder content: () -> Content
  ) {
    self.label = label
    self._isExpanded = isExpanded
    self.showViewAll = showViewAll
    self.isLastSection = isLastSection
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
        HStack(alignment: .center) {
            Label {
                Text(label.uppercased())
                    .bodySmallBoldStyle()
                    .foregroundStyle(.typographyPrimary)
            } icon: {
                FAText(iconName: "chevron-right", size: 12)
                    .foregroundColor(.typographySecondary)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                isExpanded.toggle()
            }
            if showViewAll {
                Button {
                    print("View All")
                } label: {
                    HStack(alignment: .center) {
                        Text("View All")
                            .bodyStyle()
                            .foregroundStyle(.masterPrimary)
                        FAText(iconName: "chevron-right", size: 12)
                            .foregroundColor(.masterPrimary)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.top, 8)

        

      if isExpanded {
        content
      }
      
      if !isLastSection {
        Divider()
          .background(.divider)
      }
    }
    .padding(.horizontal, 16)
    .scrollClipDisabled()
  }
}

#Preview {
  @Previewable @State var isExpanded = true
  
  HomeSectionView("Test Section", isExpanded: $isExpanded, showViewAll: true, isLastSection: false) {
    MyTimersSectionView()
  }
}
