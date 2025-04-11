import FASwiftUI
import SwiftUI

struct ReportItemView: View {
  let report: Report
  let isExpanded: Bool
  let onToggleExpand: () -> Void
  let onRun: () -> Void

  @State private var showSharedReportInfo = false // Add state for popover

  var body: some View {
    VStack(spacing: 0) {
      // Header section
      headerView
        .padding(.horizontal, 16)
        .background(Color("masterBackground"))
        .contentShape(Rectangle())
        .onTapGesture {
          withAnimation(.easeInOut(duration: 0.3)) {
            onToggleExpand()
          }
        }

      // Expanded content
      if isExpanded {
        expandedContentView
          .padding(.horizontal, 16)
          .padding(.top, 16)
          .background(Color("masterBackground"))
      }
    }
    .background(.masterBackground)
    .padding(.bottom, 16)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(Color("border").opacity(0.15))
        .frame(height: 1)
        
    }
  }

  // MARK: - Header View
  private var headerView: some View {
    HStack(spacing: 12) {
      // Title container with chevron
      HStack(spacing: 8) {
        // Chevron icon
        FAText(iconName: isExpanded ? "angle-down" : "angle-right", size: 16, style: .regular)
          .foregroundColor(Color("typographyPrimary"))

        // Report name
        Text(report.name)
          .font(.custom("Inter", size: 14))
          .fontWeight(.medium)
          .foregroundColor(Color("typographyPrimary"))
      }

      Spacer()

      // Run button
      Button(action: onRun) {
        HStack(spacing: 4) {
          FAText(iconName: "play", size: 18, style: .solid)
            .foregroundColor(Color("masterPrimary"))

          Text("Run")
            .font(.custom("Inter", size: 14))
            .fontWeight(.medium)
            .foregroundColor(Color("masterPrimary"))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color("masterPrimary").opacity(0.1))
        .cornerRadius(6)
      }
    }
  }

  // MARK: - Expanded Content View
  private var expandedContentView: some View {
    VStack(alignment: .leading, spacing: 0) {

      // Report details
      VStack(alignment: .leading, spacing: 16) {
        // Template row
        HStack {
          Text("Template:")
            .font(.custom("Inter", size: 14))
            .foregroundColor(Color("typographySecondary"))

          Spacer()

          Text(report.template)
            .font(.custom("Inter", size: 14))
            .fontWeight(.medium)
            .foregroundColor(Color("typographyPrimary"))
        }

        // Owner row
        HStack {
          Text("Owner:")
            .font(.custom("Inter", size: 14))
            .foregroundColor(Color("typographySecondary"))

          Spacer()

            HStack {
                HStack(spacing: 8) {
                    FAText(iconName: "circle-user", size: 16, style: .solid)
                        .foregroundColor(Color("typographyPrimary"))
                    Text(report.owner)
                        .font(.custom("Inter", size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(Color("typographyPrimary"))
                }
                VStack { 
                    FAText(iconName: "circle-info", size: 16)
                        .foregroundStyle(.masterPrimary)
                }
                .onTapGesture { 
                    showSharedReportInfo = true
                }
                .popover(isPresented: $showSharedReportInfo,
                         attachmentAnchor: .rect(.bounds), 
                         arrowEdge: .trailing) {                    
                    Text("You can't configure shared reports")
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            }
        }

        // View Access row
        HStack {
          Text("View Access:")
            .font(.custom("Inter", size: 14))
            .foregroundColor(Color("typographySecondary"))

          Spacer()

          Text(report.viewAccess)
            .font(.custom("Inter", size: 14))
            .fontWeight(.medium)
            .foregroundColor(Color("typographyPrimary"))
        }
      }
    }
  }

  // MARK: - Helper Methods
  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
}

// MARK: - Preview
struct ReportItemView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 16) {
      ReportItemView(
        report: Report.sampleReports()[0],
        isExpanded: true,
        onToggleExpand: {},
        onRun: {}
      )

      ReportItemView(
        report: Report.sampleReports()[1],
        isExpanded: false,
        onToggleExpand: {},
        onRun: {}
      )
    }
    .background(Color("masterBackground"))
  }
}
