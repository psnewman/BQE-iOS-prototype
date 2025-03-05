import SwiftUI

struct TagView: View {
  enum TagType {
    case red
    case grey
    case green
  }

  let text: String
  let type: TagType

  private var backgroundColor: Color {
    switch type {
    case .red:
        return .tagRedBackground
    case .green:
        return .tagGreenBackground
    case .grey:
        return .masterBackground
    }
  }

  private var borderColor: Color {
    switch type {
    case .red:
        return .tagRedBorder
    case .green:
        return .tagGreenBorder
    case .grey:
        return .border
    }
  }

  private var textColor: Color {
    switch type {
    case .red:
        return .tagRedText
    case .green:
        return .tagGreenText
    case .grey:
        return .typographyPrimary
    }
  }

  var body: some View {
    Text(text)
      .bodyStyle()
      .foregroundColor(textColor)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(backgroundColor)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .stroke(borderColor, lineWidth: 1)
      )
      .cornerRadius(4)
  }
}

#Preview {
  TagView(text: "$100", type: .green)
}
