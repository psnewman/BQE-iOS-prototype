import SwiftUI
import FASwiftUI

struct TimerHeaderView: View {
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            if isExpanded {
                Text("Active Timers")
                    .headlineStyle()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            if isExpanded {
                Spacer()
                Button {
                    withAnimation {
                        isExpanded = false
                    }
                } label: {
                    HStack {
                        FAText(iconName: "xmark", size: 16, style: .solid)
                            .foregroundColor(.typographySecondary)
                    }
                    .padding(4)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    TimerHeaderView(isExpanded: .constant(true))
}