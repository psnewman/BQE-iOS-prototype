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
      return Color("tagRedBackground")
    case .green:
      return Color("tagGreenBackground")
    case .grey:
      return Color("tagGreyBackground")
    }
  }

  private var borderColor: Color {
    switch type {
    case .red:
      return Color("tagRedBorder")
    case .green:
      return Color("tagGreenBorder")
    case .grey:
      return Color("tagGreyBorder")
    }
  }

  private var textColor: Color {
    switch type {
    case .red:
      return Color("tagRedText")
    case .green:
      return Color("tagGreenText")
    case .grey:
      return Color("tagGreyText")
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
