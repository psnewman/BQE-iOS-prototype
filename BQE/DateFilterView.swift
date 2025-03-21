//
//  DateFilterView.swift
//  BQE
//
//  Created by Paul Newman on 3/18/25.
//

import Combine
import FASwiftUI
import SwiftUI
import SwiftUIFlowLayout

// Reference the model components from DateFilterModel.swift
struct DateFilterView: View {
  // Use the view model from the DateFilterModel file
  @StateObject private var viewModel = DateFilterViewModel()

  // Closure to call when filter is applied
  var onFilterApplied: ((DateFilter, Date, Date) -> Void)?

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          HStack {
            Text("From")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
            Spacer()
            DatePicker("", selection: $viewModel.fromDate, displayedComponents: .date)
              .labelsHidden()

          }
          HStack {
            Text("To")
              .bodyStyle()
              .foregroundColor(.typographyPrimary)
            Spacer()
            DatePicker("", selection: $viewModel.toDate, displayedComponents: .date)
              .labelsHidden()

          }
        }
        .listStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .frame(maxHeight: 88, alignment: .top)

        ScrollView {
          VStack(spacing: 16) {
            // Use the sections from the view model
            ForEach(viewModel.sections, id: \.section.id) { section, filters in
              SectionView(
                title: section.displayName,
                section: filters,
                selectedFilter: $viewModel.selectedFilter
              )
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
            // Dismiss action would go here
          }
          .foregroundColor(.masterPrimary)
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
          Spacer()
          Button("Save") {
            // Apply the filter and call the closure
            viewModel.applyFilter()
            onFilterApplied?(viewModel.selectedFilter, viewModel.fromDate, viewModel.toDate)
          }
          .foregroundColor(.masterPrimary)
        }
      }
      .toolbarBackground(.masterBackground, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
    }
    .onChange(of: viewModel.selectedFilter) { oldFilter, newFilter in
      // Update date range when filter changes
      viewModel.updateDateRange(for: newFilter)
    }
  }
}

struct SectionView: View {
  let title: String
  let section: [DateFilter]
  @Binding var selectedFilter: DateFilter

  var body: some View {
    VStack(alignment: .leading) {
      SectionHeader(title: title)

      FlowLayout(mode: .scrollable, items: section) { filter in
        DateFilterTag(selectedFilter: $selectedFilter, filter: filter)
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
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
      TagView(
        text: filter.displayName,
        type: selectedFilter == filter ? .blue : .normal
      )
    }
  }
}

#Preview {
  DateFilterView()
}
