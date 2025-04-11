//
//  CardViewModel.swift
//  BQE
//
//  Created by Paul Newman on 11/11/24.
//

import FASwiftUI
import SwiftUI

enum EntryType: String, CaseIterable {
  case timeAndExpense = "Time & Expenses"
  case time = "Time Entries"
  case expense = "Expense Entries"

  var icon: String {
    switch self {
    case .timeAndExpense: return "timer"
    case .time: return "calendar-clock"
    case .expense: return "cart-circle-check"
    }
  }
}

enum BillableStatus {
  case nonBillable
  case billable
  case billed
}

class EntryItem: Identifiable, ObservableObject {
  let id: UUID = UUID()
  let entryType: EntryType
  let entryName: String
  let description: String
  @Published var memo: String
  let date: String
  let resource: String
  let project: String
  let client: String
  let units: String
  let costRate: String
  let costAmount: String
  let billRate: String
  let billedAmount: String
  let billable: BillableStatus

  init(
    entryType: EntryType,
    entryName: String,
    description: String,
    memo: String,
    date: String,
    resource: String,
    project: String,
    client: String,
    units: String,
    costRate: String,
    costAmount: String,
    billRate: String,
    billable: BillableStatus
  ) {
    self.entryType = entryType
    self.entryName = entryName
    self.description = description
    self.memo = memo
    self.date = date
    self.resource = resource
    self.project = project
    self.client = client
    self.units = units
    self.costRate = costRate
    self.costAmount = costAmount
    self.billRate = billRate

    // Calculate billedAmount by multiplying units with billRate
    if let unitsValue = Double(units.replacingOccurrences(of: ",", with: "")),
      let billRateValue = Double(
        billRate.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""))
    {
      let calculatedAmount = unitsValue * billRateValue
      self.billedAmount = String(format: "$%.2f", calculatedAmount)
    } else {
      self.billedAmount = "$0.00"
    }

    self.billable = billable
  }
}

class CardViewModel: ObservableObject {

  private let staticData:
    (
      expenseNames: [String], descriptions: [String], expenseTypes: [EntryType],
      dates: [String],
      resources: [String],
      projects: [String], clients: [String], units: [String], costRates: [String],
      costAmounts: [String], billables: [BillableStatus], billRates: [String], memos: [String]
    ) = (
      expenseNames: [
        "Design",
        "Taxi trip", "Business lunch", "Office supplies", "Client meeting",
        "Conference registration", "Hotel stay", "Flight ticket",
        "Software subscription", "Training course", "Equipment rental",
      ],
      descriptions: [
        "Design",
        "Taxi ride from airport to client office for project kickoff meeting. Including waiting time and toll fees.",
        "Business lunch with client team to discuss project requirements and timeline. Total of 4 attendees.",
        "Purchase of office supplies including notebooks, pens, and printer paper for the project team.",
        "Client meeting at downtown office to review project progress and discuss next steps.",
        "Registration for annual industry conference including workshop sessions and networking events.",
        "Two nights stay at Marriott hotel for client site visit including parking and internet.",
        "Round-trip flight ticket to New York for client presentation and project review.",
        "Annual subscription renewal for project management software license.",
        "Professional development course on new industry regulations and compliance.",
        "Rental of presentation equipment for client workshop including projector and sound system.",
      ],

      expenseTypes: [.time, .expense, .timeAndExpense],
      dates: [
        "01/29/2025", "02/01/2025", "02/04/2025", "02/06/2025",
        "8/11/2023", "8/12/2023", "8/13/2023", "8/14/2023", "8/15/2023",
      ],
      resources: [
        "Alex Hales", "Mathew Wade", "Curtis James", "Steven Smith",
        "Michael Chen", "Emma Thompson", "Sarah Lee", "John Doe", "Jane Smith",
      ],
      projects: [
        "001 - 001- Pasadena State Hospital",
        "01-01 - SKYTOWER: Project Management",
        "02-02 - GREENSCAPE: Design Phase",
        "03-03 - URBANEDGE: Construction",
        "04-04 - TECHHUB: IT Infrastructure",
      ],
      clients: [
        "Liberty Architects",
        "SKYTOWER Corp", "GREENSCAPE Innovations",
        "URBANEDGE Developers", "TECHHUB Solutions",
      ],
      units: [
        "5.00", "3.00", "6.00", "5.00",
        "1.00", "2.50", "3.75", "4.25", "7.00",
      ],
      costRates: [
        "$34.00", "$34.00", "$34.00", "$34.00",
        "$33.97", "$45.00", "$55.50", "$65.25", "$75.80",
      ],
      costAmounts: [
        "$160.00", "$201.00", "$6.00", "$435.00",
        "$33.97", "$112.50", "$208.13", "$277.31", "$379.00",
      ],
      billables: [.billable, .nonBillable, .billed],
      billRates: [
        "$57.00", "$67.00", "$1.00", "$87.00",
        "$45.00", "$65.00", "$75.00", "$85.00", "$95.00",
      ],
      memos: [
        "", "", "", "",
        "", "", "", "", "",
      ]
    )

  func generateSampleCards() -> [EntryItem] {
    var generatedCards: [EntryItem] = []

    // Generate 10 cards using consistent mapping from staticData
    for i in 0..<10 {
      // Use modulo to cycle through available data in each array
      let entryTypeIndex = i % staticData.expenseTypes.count
      let nameIndex = i % staticData.expenseNames.count
      let memoIndex = i % staticData.memos.count
      let dateIndex = i % staticData.dates.count
      let resourceIndex = i % staticData.resources.count
      let projectIndex = i % staticData.projects.count
      let clientIndex = i % staticData.clients.count
      let unitsIndex = i % staticData.units.count
      let costRateIndex = i % staticData.costRates.count
      let costAmountIndex = i % staticData.costAmounts.count
      let billRateIndex = i % staticData.billRates.count
      let billableIndex = i % staticData.billables.count

      let card = EntryItem(
        entryType: staticData.expenseTypes[entryTypeIndex],
        entryName: staticData.expenseNames[nameIndex],
        description: staticData.descriptions[nameIndex],  // Match description with name for consistency
        memo: staticData.memos[memoIndex],
        date: staticData.dates[dateIndex],
        resource: staticData.resources[resourceIndex],
        project: staticData.projects[projectIndex],
        client: staticData.clients[clientIndex],
        units: staticData.units[unitsIndex],
        costRate: staticData.costRates[costRateIndex],
        costAmount: staticData.costAmounts[costAmountIndex],
        billRate: staticData.billRates[billRateIndex],
        billable: staticData.billables[billableIndex]
      )

      generatedCards.append(card)
    }

    return generatedCards
  }
}
