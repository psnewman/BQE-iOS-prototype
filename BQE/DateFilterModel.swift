//
//  DateFilterModel.swift
//  BQE
//
//  Created on 3/20/25.
//

import Combine
import Foundation

// Define a section enum to avoid hardcoded strings
public enum FilterSection: String, CaseIterable, Identifiable {
  case all = "All"
  case specific = "Specific"
  case current = "Current"
  case past = "Past"
  case future = "Future"
  case toDate = "To-Date"
  case relative = "Relative"
  case duration = "Duration"

  public var id: String { rawValue }

  public var displayName: String {
    return self.rawValue
  }
}

public enum DateFilter: String, CaseIterable, Identifiable {
  case allDates = "All Dates"

  // Specific section
  case today = "Today"
  case yesterday = "Yesterday"

  // Current section
  case thisWeek = "This Week"
  case thisMonth = "This Month"
  case thisYear = "This Year"
  case thisQuarter = "This Quarter"
  case thisFiscalQuarter = "This Fiscal Quarter"
  case thisFiscalYear = "This Fiscal Year"
  case thisBiWeekly = "This Bi-weekly"
  case thisSemiMonthly = "This Semi-monthly"

  // Past section
  case lastWeek = "Last Week"
  case lastMonth = "Last Month"
  case lastYear = "Last Year"
  case lastQuarter = "Last Quarter"
  case lastFiscalQuarter = "Last Fiscal Quarter"
  case lastFiscalYear = "Last Fiscal Year"
  case lastBiWeekly = "Last Bi-weekly"
  case lastSemiMonthly = "Last Semi-monthly"

  // Future section
  case nextWeek = "Next Week"
  case nextMonth = "Next Month"
  case nextQuarter = "Next Quarter"
  case nextFiscalYear = "Next Fiscal Year"
  case next2Weeks = "Next 2 Weeks"
  case next12Weeks = "Next 12 Weeks"
  case next12Months = "Next 12 Months"
  case next12Quarters = "Next 12 Quarters"

  // To-Date section
  case thisWeekToDate = "This Week To Date"
  case thisMonthToDate = "This Month To Date"
  case thisQuarterToDate = "This Quarter To Date"
  case thisYearToDate = "This Year To Date"
  case thisFiscalYearToDate = "This Fiscal Year To Date"

  // Relative section
  case asOfToday = "As of Today"
  case asOfLastMonth = "As of Last Month"
  case asOfLastYear = "As of Last Year"

  // Duration section
  case last7Days = "Last 7 Days"
  case last30Days = "Last 30 Days"
  case last60Days = "Last 60 Days"
  case last90Days = "Last 90 Days"
  case last180Days = "Last 180 Days"
  case last365Days = "Last 365 Days"
  case priorYear = "Prior Year"
  case priorQuarter = "Prior Quarter"
  case priorMonth = "Prior Month"

  public var id: String { rawValue }

  public var displayName: String {
    return self.rawValue
  }

  // Return the section this filter belongs to
  public var section: FilterSection {
    switch self {
    case .allDates:
        return .all
    case .today, .yesterday:
      return .specific
    case .thisWeek, .thisMonth, .thisYear, .thisQuarter, .thisFiscalQuarter, .thisFiscalYear,
      .thisBiWeekly, .thisSemiMonthly:
      return .current
    case .lastWeek, .lastMonth, .lastYear, .lastQuarter, .lastFiscalQuarter, .lastFiscalYear,
      .lastBiWeekly, .lastSemiMonthly:
      return .past
    case .nextWeek, .nextMonth, .nextQuarter, .nextFiscalYear, .next2Weeks, .next12Weeks,
      .next12Months, .next12Quarters:
      return .future
    case .thisWeekToDate, .thisMonthToDate, .thisQuarterToDate, .thisYearToDate,
      .thisFiscalYearToDate:
      return .toDate
    case .asOfToday, .asOfLastMonth, .asOfLastYear:
      return .relative
    case .last7Days, .last30Days, .last60Days, .last90Days, .last180Days, .last365Days, .priorYear,
      .priorQuarter, .priorMonth:
      return .duration
    }
  }

  // Static method to get all filters for a specific section
  public static func filters(for section: FilterSection) -> [DateFilter] {
    return DateFilter.allCases.filter { $0.section == section }
  }
}

// ViewModel for DateFilterView
public class DateFilterViewModel: ObservableObject {
  // Published properties for UI binding
  @Published public var fromDate = Date()
  @Published public var toDate = Date()
  @Published public var selectedFilter: DateFilter = .allDates

  public var areDatePickersEnabled: Bool {
      return selectedFilter != .allDates
  }

  // Computed property to get sections with their filters
  public var sections: [(section: FilterSection, filters: [DateFilter])] {
    FilterSection.allCases.map { section in
      (section: section, filters: DateFilter.filters(for: section))
    }.filter { !$0.filters.isEmpty }
  }

  // Initialize with default values
  public init() {
    // Set default date range based on selected filter
    updateDateRange(for: selectedFilter)
  }

  // Method to update date range based on selected filter
  public func updateDateRange(for filter: DateFilter) {
    // This would contain logic to set the appropriate date range
    // based on the selected filter (e.g., this week, last month, etc.)
    // For now, using placeholder implementation
    let calendar = Calendar.current

    switch filter {
    case .allDates:
        fromDate = Date()
        toDate = Date()
    case .today:
      fromDate = Date()
      toDate = Date()
    case .thisWeek:
      let today = Date()
      let weekday = calendar.component(.weekday, from: today)
      let daysToSubtract = weekday - calendar.firstWeekday
      if let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) {
        fromDate = calendar.startOfDay(for: startOfWeek)
        if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: fromDate) {
          toDate =
            calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfWeek) ?? endOfWeek
        }
      }
    case .lastMonth:
      if let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date()) {
        let components = calendar.dateComponents([.year, .month], from: lastMonth)
        if let startOfMonth = calendar.date(from: components) {
          fromDate = startOfMonth
          if let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth),
            let endOfMonth = calendar.date(byAdding: .day, value: -1, to: nextMonth)
          {
            toDate =
              calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfMonth) ?? endOfMonth
          }
        }
      }
    default:
      // For other filters, we would implement similar date logic
      // This is a simplified version for demonstration
      break
    }
  }

  // Apply the selected filter and date range
  public func applyFilter() {
    // Logic to apply the filter to the data
    // This would typically involve updating a parent view model or making API calls
    print("Applied filter: \(selectedFilter.displayName) with date range: \(fromDate) to \(toDate)")
  }
}
