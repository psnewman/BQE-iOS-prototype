import FASwiftUI
import SwiftUI

struct ReportCenterView: View {
  @StateObject private var viewModel = ReportCenterViewModel()
  @State private var searchText = ""
  @State private var selectedTabIndex = 0

  private let tabTitles = ["Saved", "Templates"]

  var body: some View {
    VStack(spacing: 0) {
      // Header with tabs
      headerView

      // Folder selection and search
      VStack(spacing: 12) {
        // Folder dropdown
        folderSelectionView

        // Search bar
        searchBarView
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 12)

      // Report list
      reportListView
    }
    .background(Color("masterBackground"))
    .navigationBarTitleDisplayMode(.inline)
    .onChange(of: searchText) { _, newValue in
      viewModel.searchText = newValue
    }
  }

  // MARK: - Header View with Tabs
  private var headerView: some View {
    VStack(spacing: 0) {

      // Tabs
      HStack(spacing: 0) {
        ForEach(0..<tabTitles.count, id: \.self) { index in
          Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              selectedTabIndex = index
            }
          }) {
            Text(tabTitles[index])
              .bodyStyle()
              .foregroundColor(
                selectedTabIndex == index
                  ? .typographyPrimary : .typographySecondary
              )
              .frame(maxWidth: .infinity)
              .frame(height: 44)
              .overlay(alignment: .bottom) {
                Rectangle()
                  .fill(.masterPrimary)
                  .frame(height: 2)
                  .opacity(selectedTabIndex == index ? 1 : 0)
                  .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTabIndex)
              }
          }
          .buttonStyle(PlainButtonStyle())
        }
      }

      Divider()
        .background(Color("divider").opacity(0.15))
    }
  }

  // MARK: - Folder Selection View
  private var folderSelectionView: some View {
    Menu {
      ForEach(viewModel.folders, id: \.self) { folder in
        Button(action: {
          viewModel.selectedFolder = folder
        }) {
          HStack {
            Text(folder)
            if viewModel.selectedFolder == folder {
              Spacer()
              FAText(iconName: "check", size: 14, style: .solid)
                .foregroundColor(Color("#399DEB"))
            }
          }
        }
      }
    } label: {
      HStack {
        FAText(iconName: "folder", size: 16, style: .regular)
          .foregroundColor(Color("typographySecondary"))

        Text(viewModel.selectedFolder)
          .font(.custom("Inter", size: 14))
          .fontWeight(.medium)
          .foregroundColor(Color("typographyPrimary"))

        Spacer()

        FAText(iconName: "chevron-down", size: 12, style: .solid)
          .foregroundColor(Color("typographySecondary"))
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 8)
      .background(Color("fieldBackground"))
      .cornerRadius(6)
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color("border").opacity(0.2), lineWidth: 1)
      )
    }
  }

  // MARK: - Search Bar View
  private var searchBarView: some View {
    HStack(spacing: 8) {
      FAText(iconName: "magnifying-glass", size: 14, style: .regular)
        .foregroundColor(Color("typographySecondary"))
        .padding(.leading, 2)

      TextField("Search", text: $searchText)
        .font(.custom("Inter", size: 14))
        .foregroundColor(Color("typographyPrimary"))

      if !searchText.isEmpty {
        Button(action: {
          searchText = ""
        }) {
          FAText(iconName: "xmark", size: 14, style: .regular)
            .foregroundColor(Color("typographySecondary"))
        }
        .padding(.trailing, 2)
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(Color("fieldBackground"))
    .cornerRadius(6)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color("border"), lineWidth: 1)
    )
  }

  // MARK: - Report List View
  private var reportListView: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        let reports = viewModel.filteredReports()

        if reports.isEmpty {
          emptyStateView
            .padding(.horizontal, 20)
        } else {
          ForEach(reports) { report in
            ReportItemView(
              report: report,
              isExpanded: viewModel.isReportExpanded(reportId: report.id),
              onToggleExpand: {
                withAnimation(.easeInOut(duration: 0.3)) {
                  viewModel.toggleReportExpansion(reportId: report.id)
                }
              },
              onRun: {
                viewModel.runReport(reportId: report.id)
              }
            )
          }
        }
      }
      .background(.masterBackground)
      .padding(.top, 8)
    }
  }

  // MARK: - Empty State View
  private var emptyStateView: some View {
    VStack(spacing: 16) {
      FAText(iconName: "file-circle-exclamation", size: 48, style: .light)
        .foregroundColor(Color("typographySecondary").opacity(0.5))
        .padding(.bottom, 8)

      Text("No Reports Found")
        .font(.system(size: 18, weight: .semibold))
        .foregroundColor(Color("typographyPrimary"))

      Text("Try adjusting your search or filter criteria")
        .font(.system(size: 15))
        .foregroundColor(Color("typographySecondary"))
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 60)
  }
}

// MARK: - Preview
#Preview {
  ReportCenterView()
}
