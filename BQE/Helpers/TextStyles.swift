import SwiftUI

extension View {
    // Caption style
    func bodySmallStyle() -> some View {
        self.modifier(BodySmallModifier())
    }
    
    // Caption bold style
    func bodySmallBoldStyle() -> some View {
        self.modifier(BodySmallBoldModifier())
    }
    
    // Body style
    func bodyStyle() -> some View {
        self.modifier(BodyModifier())
    }
    
    // Body bold style
    func bodyBoldStyle() -> some View {
        self.modifier(BodyBoldModifier())
    }
    
    // Headline style
    func headlineStyle() -> some View {
        self.modifier(HeadlineModifier())
    }
    
    // Title style
    func titleStyle() -> some View {
        self.modifier(TitleModifier())
    }
}

// Define the modifier structs
struct BodySmallModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 12, relativeTo: .caption))
            .fontWeight(.regular)
            .lineSpacing(4)
    }
}

struct BodySmallBoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 12, relativeTo: .caption))
            .fontWeight(.bold)
            .lineSpacing(6)
    }
}

struct BodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 14, relativeTo: .body))
            .fontWeight(.regular)
            .lineSpacing(6)
    }
}

struct BodyBoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 14, relativeTo: .body))
            .fontWeight(.semibold)
            .lineSpacing(6)
    }
}

struct HeadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 16, relativeTo: .headline))
            .fontWeight(.semibold)
            .lineSpacing(8)
    }
}

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter", size: 24, relativeTo: .title))
            .fontWeight(.bold)
    }
}
