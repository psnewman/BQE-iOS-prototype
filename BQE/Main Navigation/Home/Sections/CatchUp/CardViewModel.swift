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

struct ExpenseCard: Identifiable {
  let id = UUID()
  let expenseType: EntryType
  let expenseName: String
  let date: String
  let resource: String
  let project: String
  let client: String
  let units: String
  let costRate: String
  let costAmount: String
}

class CardViewModel: ObservableObject {
  @Published var cards: [ExpenseCard] = []
  @Published var approvedCards: [ExpenseCard] = []
  @Published var rejectedCards: [ExpenseCard] = []
  @Published var expensesLeft: Int = 10

  private let staticData:
    (
      expenseNames: [String], expenseTypes: [EntryType], dates: [String], resources: [String],
      projects: [String], clients: [String], units: [String], costRates: [String],
      costAmounts: [String]
    ) = (
      expenseNames: [
        "Taxi trip", "Business lunch", "Office supplies", "Client meeting",
        "Conference registration", "Hotel stay", "Flight ticket",
        "Software subscription", "Training course", "Equipment rental",
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
      costAmounts: ["$33.97", "$112.50", "$208.13", "$277.31", "$379.00"]
    )

  func loadCards() {
    cards = (0..<10).map { index in
      ExpenseCard(
        expenseType: staticData.expenseTypes[index % staticData.expenseTypes.count],
        expenseName: staticData.expenseNames[index],
        date: staticData.dates[index % staticData.dates.count],
        resource: staticData.resources[index % staticData.resources.count],
        project: staticData.projects[index % staticData.projects.count],
        client: staticData.clients[index % staticData.clients.count],
        units: staticData.units[index % staticData.units.count],
        costRate: staticData.costRates[index % staticData.costRates.count],
        costAmount: staticData.costAmounts[index % staticData.costAmounts.count]
      )
    }
    expensesLeft = cards.count
  }

  func removeTopCard(isApproved: Bool) {
    guard !cards.isEmpty else { return }

    let removedCard: ExpenseCard = cards.removeFirst()
    if isApproved {
      approvedCards.append(removedCard)
    } else {
      rejectedCards.append(removedCard)
    }
    expensesLeft -= 1
  }

  func resetCards() {
    loadCards()
    approvedCards.removeAll()
    rejectedCards.removeAll()
  }
}
