import SwiftUI
import FASwiftUI

struct TimerControlsView: View {
    @Binding var isExpanded: Bool

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                if isExpanded {
                    HStack {
                        FAText(
                            iconName: "pause",
                            size: 16,
                            style: .solid
                        )
                        .foregroundColor(.typographyPrimary)
                    }
                    .frame(width: 32, height: 32)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .transition(.opacity)
                }

                Button {
                    withAnimation {
                        isExpanded = true
                    }
                } label: {
                    HStack {
                        Text("00:00:00")
                            .bodyStyle()
                            .foregroundColor(.typographyPrimary)
                    }
                    .padding(.horizontal, 8)
                    .frame(maxHeight: 32)
                    .background(Color.yellow)
                    .cornerRadius(8)
                }
            }

            if isExpanded {
                Spacer()
                HStack(alignment: .center, spacing: 16) {
                    HStack(spacing: 0) {
                        HStack {
                            FAText(
                                iconName: "flag-checkered",
                                size: 16,
                                style: .solid
                            )
                        }
                        .frame(width: 32, height: 32)
                        .background(Color.clear)
                        .cornerRadius(8)

                        HStack(alignment: .center) {
                            Text("Finalize")
                                .bodyStyle()
                        }
                        .frame(maxHeight: 32)
                    }
                    .foregroundColor(.masterPrimary)

                    HStack {
                        FAText(
                            iconName: "ellipsis",
                            size: 16,
                            style: .solid
                        )
                        .foregroundColor(.typographyPrimary)
                    }
                    .frame(width: 32, height: 32)
                    .background(Color.clear)
                    .cornerRadius(8)
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(
                            with: .opacity
                        ),
                        removal: .move(edge: .leading).combined(
                            with: .opacity
                        )
                    )
                )
            }
        }
    }
}

#Preview {
    TimerControlsView(isExpanded: .constant(true))
}