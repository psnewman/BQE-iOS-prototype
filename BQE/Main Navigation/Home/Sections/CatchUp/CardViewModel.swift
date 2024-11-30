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
    case .time: return "stopwatch"
    case .expense: return "cart-shopping"
    }
  }
}

enum BillableStatus {
  case nonBillable
  case billable
  case billed
}

struct EntryItem: Identifiable {
  let id: UUID = UUID()
  let entryType: EntryType
  let entryName: String
  let description: String
  let date: String
  let resource: String
  let project: String
  let client: String
  let units: String
  let costRate: String
  let costAmount: String
  let billable: BillableStatus
}

class CardViewModel: ObservableObject {
  @Published var cards: [EntryItem] = []
  @Published var approvedCards: [EntryItem] = []
  @Published var rejectedCards: [EntryItem] = []
  @Published var expensesLeft: Int = 10

  private let staticData:
    (
      expenseNames: [String], descriptions: [String], expenseTypes: [EntryType], dates: [String],
      resources: [String],
      projects: [String], clients: [String], units: [String], costRates: [String],
      costAmounts: [String], billables: [BillableStatus]
    ) = (
      expenseNames: [
        "Taxi trip", "Business lunch", "Office supplies", "Client meeting",
        "Conference registration", "Hotel stay", "Flight ticket",
        "Software subscription", "Training course", "Equipment rental",
      ],
      descriptions: [
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
      expenseTypes: [EntryType.expense, .time, .timeAndExpense],
      dates: ["8/11/2023", "8/12/2023", "8/13/2023", "8/14/2023", "8/15/2023"],
      resources: [
        "Curtis Jameson", "Emma Thompson", "Alex Rodriguez", "Sarah Lee", "Michael Chen",
      ],
      projects: [
        "00-00 - FOUNTAINHEAD: Business Development",
        "01-01 - SKYTOWER: Project Management",
        "02-02 - GREENSCAPE: Design Phase",
        "03-03 - URBANEDGE: Construction",
        "04-04 - TECHHUB: IT Infrastructure",
      ],
      clients: [
        "FOUNTAINHEAD A+E", "SKYTOWER Corp", "GREENSCAPE Innovations",
        "URBANEDGE Developers", "TECHHUB Solutions",
      ],
      units: ["1.00", "2.50", "3.75", "4.25", "5.00"],
      costRates: ["$33.97", "$45.00", "$55.50", "$65.25", "$75.80"],
      costAmounts: ["$33.97", "$112.50", "$208.13", "$277.31", "$379.00"],
      billables: [.nonBillable, .billable, .billed]
    )

  func loadCards() {
    cards = (0..<10).map { index in
      EntryItem(
        entryType: staticData.expenseTypes[index % staticData.expenseTypes.count],
        entryName: staticData.expenseNames[index],
        description: staticData.descriptions[index],
        date: staticData.dates[index % staticData.dates.count],
        resource: staticData.resources[index % staticData.resources.count],
        project: staticData.projects[index % staticData.projects.count],
        client: staticData.clients[index % staticData.clients.count],
        units: staticData.units[index % staticData.units.count],
        costRate: staticData.costRates[index % staticData.costRates.count],
        costAmount: staticData.costAmounts[index % staticData.costAmounts.count],
        billable: staticData.billables[index % staticData.billables.count]
      )
    }
    expensesLeft = cards.count
  }

  func removeTopCard(isApproved: Bool) {
    guard !cards.isEmpty else { return }

    let removedCard: EntryItem = cards.removeFirst()
    if isApproved {
      approvedCards.append(removedCard)
    } else {
      rejectedCards.append(removedCard)
    }
    expensesLeft -= 1
  }

  func skipTopCard() {
    guard !cards.isEmpty else { return }

    let removedCard: EntryItem = cards.removeFirst()
    rejectedCards.append(removedCard)
    expensesLeft -= 1
  }

  func resetCards() {
    loadCards()
    approvedCards.removeAll()
    rejectedCards.removeAll()
  }
}
