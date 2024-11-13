//
//  HomeSection.swift
//  BQE
//
//  Created by Paul Newman on 11/10/24.
//
//

import SwiftUI
import FASwiftUI

struct HomeSectionView<Content: View>: View {
    let label: String
    let content: () -> Content
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HomeSectionLabel(label: label, isExpanded: isExpanded)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }
            
            if isExpanded { // Only render content when expanded
                VStack {
                    content()
                }
                .transition(.scaleY) // Use the custom scaleY transition
            }
            
            Divider()
                .background(.divider)
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.3), value: isExpanded) // Animate the whole VStack
        .scrollClipDisabled()

    }
}

struct HomeSectionLabel: View {
    let label: String
    var isExpanded: Bool
    
    var body: some View {
        HStack {
            FAText(iconName: "chevron-down", size: 12)
                .foregroundColor(.typographySecondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.easeInOut(duration: 0.3), value: isExpanded)
            Text(label.uppercased())
                .captionBoldStyle()
                .foregroundStyle(.typographyPrimary)
        }
        .padding(.top, 8)
    }
    
    init(label: String, isExpanded: Bool) {
        self.label = label
        self.isExpanded = isExpanded
    }
}

struct ScaleYTransition: ViewModifier {
    let scale: CGFloat
    
    init(scale: CGFloat = 0.01) {
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(CGSize(width: 1, height: scale), anchor: .top)
    }
}

extension AnyTransition {
    static var scaleY: AnyTransition {
        AnyTransition.modifier(
            active: ScaleYTransition(scale: 0.01),
            identity: ScaleYTransition(scale: 1)
        )
    }
}

#Preview {
    VStack {
        HomeSectionView(label: "Test Section") {
//            Text("This is the content of the section")
            MyTimersSectionView()
        }
    }
}
