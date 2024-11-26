import SwiftUI

struct CardStyle: ViewModifier {
    let offset: CGSize
    let dragThreshold: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(Color(.masterBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(.border, lineWidth: 0.5)
            )
            
    }
}

extension View {
    func cardStyle(offset: CGSize, dragThreshold: CGFloat) -> some View {
        modifier(CardStyle(offset: offset, dragThreshold: dragThreshold))
    }
}
