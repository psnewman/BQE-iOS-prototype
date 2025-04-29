import SwiftUI

struct TimeCardRowView: View {
  let entry: TimeCardActivityEntry
  
  var body: some View {
    VStack(spacing: 0) {
      projectInfoView
      daysRowView
    }
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(.border, lineWidth: 1)
    )
    .padding(.horizontal, 16)
  }

  private var projectInfoView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(entry.title)
          .bodyBoldStyle().foregroundColor(.typographyPrimary)
          .lineLimit(1)
        Text(entry.subtitle)
          .bodySmallStyle().foregroundColor(.typographyPrimary)
          .lineLimit(1)
      }
      Spacer()
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(Color.cardSecondary)
    .clipShape(UnevenRoundedRectangle(
        cornerRadii: .init(
            topLeading: 12,
            bottomLeading: 0,
            bottomTrailing: 0,
            topTrailing: 12
        )
    ))
    .overlay(
      Rectangle()
        .frame(height: 1)
        .foregroundColor(.border),
      alignment: .bottom
    )
  }

  private var daysRowView: some View {
    HStack(spacing: 0) {
      ForEach(entry.dailyHours) { daily in
        VStack {
          Text(String(format: "%.2f", daily.hours))
            .bodySmallStyle()
            .foregroundColor(.typographyPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.masterBackground)
        .overlay(
          Rectangle()
            .frame(width: 1)
            .foregroundColor(.border),
          alignment: .trailing
        )

      }
    }
  }
}

#Preview {
  VStack {
    ForEach(0..<3) { i in
      TimeCardRowView(entry: TimeCardActivityEntry.sample(projectIndex: i))
    }
  }
}
