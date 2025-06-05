//
//  ReportConfigurationView.swift
//  BQE
//
//  Created by Paul Newman on 4/10/25.
//

import FASwiftUI
import SwiftUI

struct ReportConfigurationView: View {
  @Environment(\.dismiss) var dismiss

  // State variables
  @State private var dateRange = "This Year"
  @State private var isBillable = false
  @State private var level1Grouping = "Employee"
  @State private var level2Grouping = ""
  @State private var level3Grouping = ""
  @State private var viewType = "Time and Expense"
  @State private var itemsTiedTo = "All (Default)"
  @State private var includeWUD = false

  var body: some View {
    NavigationView {
      List {
        // MARK: - Callout
        Section {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        FAText(iconName: "circle-info", size: 16, style: .solid)
                            .foregroundColor(.masterPrimary)
                        Text("Temporary Configuration")
                            .headlineStyle()
                            .foregroundColor(.typographyPrimary)
                    }
                    Text(
                        "These settings will be active only for the current report launch. To save changes, use the web version."
                    )
                    .bodyStyle()
                    .foregroundColor(.typographySecondary)
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.masterBackgroundSecondary)
                .listRowSeparator(.hidden)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.88, green: 0.95, blue: 1))
            .cornerRadius(8)
        }
        .listRowSeparator(.hidden)

        

        // MARK: - Filters Section
        Section(
          header: Text("Filters")
            .headlineStyle()
            .foregroundColor(.typographyPrimary)
            .textCase(nil)
        ) {
          // Date Filter Row
          HStack {
            Text("Time Expense Date")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
            Spacer()
            Text(dateRange)
              .bodyStyle()
              .foregroundColor(.typographySecondary)
          }
          .listRowSeparator(.hidden)

          // Billable Toggle Row
          Toggle(isOn: $isBillable) {
            Text("Billable")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
          }
          .toggleStyle(SwitchToggleStyle(tint: .masterPrimary))
          .listRowSeparator(.hidden)
        }

        // MARK: - Display Options Section
        Section(
          header: Text("Display Options")
            .headlineStyle()
            .foregroundColor(.typographyPrimary)
            .textCase(nil)
        ) {
          // Group By Section
          Section(
            header: Text("Group By")
              .bodySmallBoldStyle()
              .foregroundColor(.typographySecondary)
              .textCase(nil)
          ) {
            HStack {
              Text("Level 1")
                .bodyStyle()
                .foregroundColor(.typographyPrimary)
              Spacer()
              Text(level1Grouping)
                .bodyStyle()
                .foregroundColor(.typographySecondary)
            }
            .listRowSeparator(.hidden)

            HStack {
              Text("Level 2")
                .bodyStyle()
                .foregroundColor(.typographyPrimary)
              Spacer()
              Text(level2Grouping)
                .bodyStyle()
                .foregroundColor(.typographySecondary)
            }
            .listRowSeparator(.hidden)

            HStack {
              Text("Level 3")
                .bodyStyle()
                .foregroundColor(.typographyPrimary)
              Spacer()
              Text(level3Grouping)
                .bodyStyle()
                .foregroundColor(.typographySecondary)
            }
            .listRowSeparator(.hidden)
          }

          // View Options
          HStack {
            Text("View")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
            Spacer()
            Text(viewType)
              .bodyStyle()
              .foregroundColor(.typographySecondary)
          }
          .listRowSeparator(.hidden)

          HStack {
            Text("Items Tied To")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
            Spacer()
            Text(itemsTiedTo)
              .bodyStyle()
              .foregroundColor(.typographySecondary)
          }
          .listRowSeparator(.hidden)

          // WUD Toggle
          Toggle(isOn: $includeWUD) {
            Text("Charge column includes WUD")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
          }
          .toggleStyle(SwitchToggleStyle(tint: .masterPrimary))
          .listRowSeparator(.hidden)
        }
        .listRowSeparator(.hidden)

      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      .background(.masterBackground)
      .navigationTitle("Configuration")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Run") {
            // Run action
          }
          .bodyBoldStyle()
          .foregroundColor(.typographyPrimary)
        }
      }
    }
  }
}

#Preview {
  ReportConfigurationView()
}
