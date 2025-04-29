import SwiftUI
import FASwiftUI

struct TimeCardTotalBarView: View {
  var body: some View {
      HStack {
          HStack {
              Text("Weekly total: 27h")
                  .bodyStyle()
                  .foregroundColor(.typographyPrimary)
              Spacer()
              Button(action: {
                  // Submit action
              }) {
                  Text("Submit All")
                      .bodyStyle()
                      .foregroundColor(.masterPrimary)
                      .frame(height: 32)
                      .padding(.horizontal, 12)
              }
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("masterPrimary"), lineWidth: 1)
              )
          }
          .padding(.leading, 16)
          .padding([.top, .bottom, .trailing], 8)
          .background(.masterBackground)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("border"), lineWidth: 1)
          )
          .shadow(
            color: Color.black.opacity(0.05),
            radius: 2,
            x: 0,
            y: 2
          )
          .shadow(
            color: Color.black.opacity(0.1),
            radius: 4,
            x: 0, 
            y: 4
          )
          .padding()
      }
  }
}

#Preview {
  TimeCardTotalBarView()
}
