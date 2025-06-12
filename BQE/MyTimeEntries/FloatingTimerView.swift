import SwiftUI
import FASwiftUI

struct FloatingTimerView: View {
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack {
            TimerHeaderView(isExpanded: $isExpanded)
            VStack {
              TimerDetailsView(isExpanded: $isExpanded)
              TimerControlsView(isExpanded: $isExpanded)
            }
            .padding(isExpanded ? 12 : 4)
            .overlay(RoundedRectangle(cornerRadius: isExpanded ? 8 : 12).stroke(.yellow, lineWidth: 1))
            TimerFooterView(isExpanded: $isExpanded)
        }
        .padding(.horizontal, isExpanded ? 12 : 4)
        .padding(.vertical, isExpanded ? 16 : 4)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 8 : 16))
        .shadow(
            color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.05),
            radius: 3,
            x: 0,
            y: 4
        )
        .shadow(
            color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.1),
            radius: 8,
            x: 0,
            y: 12
        )
    }
}

#Preview {
    FloatingTimerView()
}
