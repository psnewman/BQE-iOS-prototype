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
       let billRateValue = Double(billRate.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
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
        "Software subscription", "Training course", "Equipment rental"
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
        "Rental of presentation equipment for client workshop including projector and sound system."
      ],

      expenseTypes: [.time, .expense, .timeAndExpense],
      dates: [
        "01/29/2025", "02/01/2025", "02/04/2025", "02/06/2025",
        "8/11/2023", "8/12/2023", "8/13/2023", "8/14/2023", "8/15/2023"
      ],
      resources: [
        "Alex Hales", "Mathew Wade", "Curtis James", "Steven Smith",
        "Michael Chen", "Emma Thompson", "Sarah Lee", "John Doe", "Jane Smith"
      ],
      projects: [
        "001 - 001- Pasadena State Hospital",
        "01-01 - SKYTOWER: Project Management",
        "02-02 - GREENSCAPE: Design Phase",
        "03-03 - URBANEDGE: Construction",
        "04-04 - TECHHUB: IT Infrastructure"
      ],
      clients: [
        "Liberty Architects",
        "SKYTOWER Corp", "GREENSCAPE Innovations",
        "URBANEDGE Developers", "TECHHUB Solutions"
      ],
      units: [
        "5.00", "3.00", "6.00", "5.00",
        "1.00", "2.50", "3.75", "4.25", "7.00"
      ],
      costRates: [
        "$34.00", "$34.00", "$34.00", "$34.00",
        "$33.97", "$45.00", "$55.50", "$65.25", "$75.80"
      ],
      costAmounts: [
        "$160.00", "$201.00", "$6.00", "$435.00",
        "$33.97", "$112.50", "$208.13", "$277.31", "$379.00"
      ],
      billables: [.billable, .nonBillable, .billed], // Billable first to match screenshots
      billRates: [
        "$57.00", "$67.00", "$1.00", "$87.00",
        "$45.00", "$65.00", "$75.00", "$85.00", "$95.00"
      ],
      memos: [
        "", "", "", "",
        "", "", "", "", ""
      ]
    )

  func generateSampleCards() -> [EntryItem] {
    var generatedCards: [EntryItem] = []

    // First 4 cards use exact data from screenshots
    for i in 0..<4 {
      let card = EntryItem(
        entryType: staticData.expenseTypes[0], // .time
        entryName: staticData.expenseNames[0], // "Design"
        description: staticData.descriptions[0], // "Design"
        memo: staticData.memos[i],
        date: staticData.dates[i],
        resource: staticData.resources[i],
        project: staticData.projects[0], // Pasadena State Hospital
        client: staticData.clients[0], // Liberty Architects
        units: staticData.units[i],
        costRate: staticData.costRates[i],
        costAmount: staticData.costAmounts[i],
        billRate: staticData.billRates[i],
        billable: staticData.billables[0] // .billable
      )

      generatedCards.append(card)
    }

    // Remaining cards use consistent indices (not random)
    for i in 4..<10 {
      let index = i % 5 + 1 // Use indices 1-5 for variety but consistently
      
      let card = EntryItem(
        entryType: staticData.expenseTypes[i % staticData.expenseTypes.count],
        entryName: staticData.expenseNames[index],
        description: staticData.descriptions[index],
        memo: staticData.memos[i % staticData.memos.count],
        date: staticData.dates[i % staticData.dates.count],
        resource: staticData.resources[i % staticData.resources.count],
        project: staticData.projects[i % staticData.projects.count],
        client: staticData.clients[i % staticData.clients.count],
        units: staticData.units[i % staticData.units.count],
        costRate: staticData.costRates[i % staticData.costRates.count],
        costAmount: staticData.costAmounts[i % staticData.costAmounts.count],
        billRate: staticData.billRates[i % staticData.billRates.count],
        billable: staticData.billables[i % staticData.billables.count]
      )

      generatedCards.append(card)
    }

    return generatedCards
  }
}
