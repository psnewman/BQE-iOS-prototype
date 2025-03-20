//
//  DateFilterView.swift
//  BQE
//
//  Created by Paul Newman on 3/18/25.
//

import FASwiftUI
import SwiftUI

struct DateFilterView: View {
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var selectedFilter: DateFilter = .thisWeek
    
    // Function to create rows of tags based on available width
    private func createRows(from filters: [DateFilter], availableWidth: CGFloat) -> [[DateFilter]] {
        var rows: [[DateFilter]] = [[]]
        var currentRowWidth: CGFloat = 0
        let tagSpacing: CGFloat = 8
        
        // Calculate approximate width for each tag
        // This is an estimation - in a real app, you might want to measure text more precisely
        for filter in filters {
            let tagWidth = estimateWidth(for: filter.displayName) + 16  // 16 for horizontal padding inside tag
            
            if currentRowWidth + tagWidth > availableWidth && !rows[rows.count - 1].isEmpty {
                // Start a new row
                rows.append([])
                currentRowWidth = 0
            }
            
            // Add to current row
            rows[rows.count - 1].append(filter)
            currentRowWidth += tagWidth + tagSpacing
        }
        
        return rows
    }
    
    // Helper to estimate text width
    private func estimateWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)  // Match the font size in TagView
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    HStack {
                        Text("From")
                            .bodyStyle()
                            .foregroundColor(.typographyPrimary)
                        Spacer()
                        DatePicker("", selection: $fromDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    HStack {
                        Text("To")
                            .bodyStyle()
                            .foregroundColor(.typographyPrimary)
                        Spacer()
                        DatePicker("", selection: $toDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
        .listStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(maxHeight: 88, alignment: .top)

        ScrollView {
          VStack(spacing: 16) {

            let filters: [[DateFilter]] = [
              [.today, .yesterday],
              [
                .thisWeek, .thisMonth, .thisYear, .thisQuarter, .thisFiscalQuarter,
                .thisFiscalYear,
                .thisBiWeekly, .thisSemiMonthly,
              ],
              [
                .lastWeek, .lastMonth, .lastQuarter, .lastYear, .lastFiscalQuarter,
                .lastFiscalYear,
                .lastBiWeekly, .lastSemiMonthly,
              ],
              [.next2Weeks, .next12Weeks, .next12Months, .next12Quarters],
              [.nextWeek, .nextMonth, .nextFiscalYear],
              [
                .thisWeekToDate, .thisMonthToDate, .thisQuarterToDate, .thisYearToDate,
                .thisFiscalYearToDate,
              ],
              [.asOfToday, .asOfLastMonth, .asOfLastYear],
              [
                .last7Days, .last30Days, .last60Days, .last90Days, .last180Days, .last365Days,
                .priorYear, .priorQuarter, .priorMonth,
              ],
            ]

            let sectionTitles = [
              "Specific", "Current", "Past", "Future", "Rolling", "To-Date", "Relative",
            ]

            ForEach(Array(zip(filters, sectionTitles)), id: \.0) { section, title in
              SectionHeader(title: title)

              // Use HStack + VStack for flowing tags layout
              VStack(alignment: .leading, spacing: 8) {
                // Create rows of tags
                let rows = createRows(
                  from: section, availableWidth: UIScreen.main.bounds.width - 32)  // 32 for horizontal padding

                ForEach(0..<rows.count, id: \.self) { rowIndex in
                  HStack(spacing: 8) {
                    ForEach(rows[rowIndex], id: \.self) { filter in
                      DateFilterTag(selectedFilter: $selectedFilter, filter: filter)
                    }
                  }
                }
              }
              .padding(.horizontal, 16)
              .frame(maxWidth: .infinity, alignment: .leading)
            }

          }
          .padding(.vertical, 8)
        }
      }
      .background(Color(.systemBackground))
      .navigationTitle("Client Since")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") {

          }
          .foregroundColor(.masterPrimary)
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
          Spacer()
          Button("Save") {

          }
          .foregroundColor(.masterPrimary)
        }
      }
      .toolbarBackground(.masterBackground, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
    }
  }
}

struct SectionHeader: View {
  let title: String

  var body: some View {
    Text(title.uppercased())
      .bodySmallStyle()
      .foregroundColor(.typographySecondary)
      .padding(.horizontal, 16)
      .padding(.top, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct DateFilterTag: View {
  @Binding var selectedFilter: DateFilter
  let filter: DateFilter

  var body: some View {
    Button {
      withAnimation {
        selectedFilter = filter
      }
    } label: {
      TagView(text: filter.displayName, type: .normal)
    }
  }
}

enum DateFilter: String, CaseIterable {
  case today = "Today"
  case yesterday = "Yesterday"
  case thisWeek = "This Week"
  case thisMonth = "This Month"
  case thisYear = "This Year"
  case lastWeek = "Last Week"
  case lastMonth = "Last Month"
  case lastYear = "Last Year"
  case nextWeek = "Next Week"
  case nextMonth = "Next Month"
  case nextFiscalYear = "Next Fiscal Year"
  case thisQuarter = "This Quarter"
  case lastQuarter = "Last Quarter"
  case nextQuarter = "Next Quarter"
  case thisWeekToDate = "This Week To Date"
  case thisMonthToDate = "This Month To Date"
  case thisYearToDate = "This Year To Date"
  case thisFiscalQuarter = "This Fiscal Quarter"
  case thisFiscalYear = "This Fiscal Year"
  case thisBiWeekly = "This Bi-weekly"
  case thisSemiMonthly = "This Semi-monthly"
  case lastFiscalQuarter = "Last Fiscal Quarter"
  case lastFiscalYear = "Last Fiscal Year"
  case lastBiWeekly = "Last Bi-weekly"
  case lastSemiMonthly = "Last Semi-monthly"
  case next2Weeks = "Next 2 Weeks"
  case next12Weeks = "Next 12 Weeks"
  case next12Months = "Next 12 Months"
  case next12Quarters = "Next 12 Quarters"
  case thisQuarterToDate = "This Quarter To Date"
  case thisFiscalYearToDate = "This Fiscal Year To Date"
  case asOfToday = "As of Today"
  case asOfLastMonth = "As of Last Month"
  case asOfLastYear = "As of Last Year"
  case last7Days = "Last 7 Days"
  case last30Days = "Last 30 Days"
  case last60Days = "Last 60 Days"
  case last90Days = "Last 90 Days"
  case last180Days = "Last 180 Days"
  case last365Days = "Last 365 Days"
  case priorYear = "Prior Year"
  case priorQuarter = "Prior Quarter"
  case priorMonth = "Prior Month"

  var displayName: String {
    return self.rawValue
  }
}

#Preview {
  DateFilterView()
}
