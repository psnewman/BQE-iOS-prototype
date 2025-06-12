import FASwiftUI
import SwiftUI

struct TimerView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
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
      
      HStack {
        HStack(alignment: .center) {
          HStack {
            HStack {
              FAText(
                iconName: "play",
                size: 16,
                style: .solid
              )
              .foregroundColor(.typographyPrimary)
            }
            .frame(width: 32, height: 32)
            .offset(x: 1)
            .background(Color.masterBackgroundSecondary)
            .cornerRadius(8)
            .transition(.opacity)
            
            
            Button {
              //         Action
            } label: {
              HStack {
                Text("00:00:00")
                  .bodyStyle()
                  .foregroundColor(.typographyPrimary)
              }
              .padding(.horizontal, 8)
              .frame(maxHeight: 32)
              .background(Color.masterBackgroundSecondary)
              .cornerRadius(8)
            }
          }
          
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
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.border, lineWidth: 1)
    )
  }
}

#Preview {
  TimerView()
}
