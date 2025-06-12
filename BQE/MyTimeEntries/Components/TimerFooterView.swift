import SwiftUI

struct TimerFooterView: View {
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            if isExpanded {
                HStack {
                    Text("Hide floating timer")
                        .bodyStyle()
                        .foregroundStyle(.masterPrimary)
                }
                .frame(maxHeight: 32)
                .transition(.move(edge: .trailing).combined(with: .opacity))

                if isExpanded {
                    Spacer()
                    Button {
                        // Button action
                    } label: {
                        Text("View My Time Entries")
                            .bodyStyle()
                            .foregroundStyle(.masterPrimary)
                    }
                    .buttonStyle(.plain)
                    .frame(maxHeight: 32)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.masterPrimary, lineWidth: 1)
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
        }
        .padding(.top, isExpanded ? 16 : 0)
    }
}

#Preview {
    TimerFooterView(isExpanded: .constant(true))
}