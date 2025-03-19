import SwiftUI

struct TagView: View {
    let text: String
    let type: TagType

    enum TagType {
        case normal
        case red
        case grey
        case green
    }

    var backgroundColor: Color {
        switch type {
        case .normal:
            return Color.masterBackground
        case .red:
            return Color.red.opacity(0.2)
        case .grey:
            return Color.gray.opacity(0.2)
        case .green:
            return Color.green.opacity(0.2)
        }
    }

    var borderColor: Color {
        switch type {
        case .normal:
            return .border
        case .red:
            return Color.red
        case .grey:
            return Color.gray
        case .green:
            return Color.green
        }
    }

    var foregroundColor: Color {
        switch type {
        case .normal:
            return .typographyPrimary
        case .red:
            return Color.red
        case .grey:
            return Color.gray
        case .green:
            return Color.green
        }
    }

    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(borderColor, lineWidth: 0.5)
            )
    }
}

#Preview {
    TagView(text: "$100.00", type: .normal)
}
