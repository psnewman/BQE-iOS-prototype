import SwiftUI

struct TimerDetailsView: View {
  @Binding var isExpanded: Bool

  var body: some View {
    if isExpanded {
      HStack {
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
        .padding(.bottom, 8)
        .transition(
          .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
          )
        )
        Spacer()
      }
    }
  }
}

#Preview {
  TimerDetailsView(isExpanded: .constant(true))
}
