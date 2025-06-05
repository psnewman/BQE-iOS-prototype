import Foundation
import SwiftUI

// Enum to define different report types
enum ReportType: String, CaseIterable, Identifiable {
    case time = "Time"
    case expense = "Expense"
    case project = "Project"
    case staff = "Staff"
    case client = "Client"
    case invoice = "Invoice"
    case payment = "Payment"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .time: return "calendar-clock"
        case .expense: return "cart-circle-check"
        case .project: return "fa-briefcase"
        case .staff: return "user-crown"
        case .client: return "user-crown"
        case .invoice: return "file-invoice-dollar"
        case .payment: return "money-check-dollar"
        }
    }
    
    var color: Color {
        switch self {
        case .time: return Color("masterPrimary")
        case .expense: return Color("orange")
        case .project: return Color("purple")
        case .staff: return Color("green")
        case .client: return Color("blue")
        case .invoice: return Color("red")
        case .payment: return Color("teal")
        }
    }
}

// Model for a saved report
struct Report: Identifiable {
    let id: UUID = UUID()
    let name: String
    let type: ReportType
    let template: String
    let owner: String
    let viewAccess: String
    let isExpanded: Bool
    
    // Sample data generator
    static func sampleReports() -> [Report] {
        return [
            Report(
                name: "P&L Accrual", 
                type: .project, 
                template: "Activity by Project",
                owner: "Alice Shapiro",
                viewAccess: "Only me",
                isExpanded: true
            ),
            Report(
                name: "Expense Detail", 
                type: .expense, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            ),
            Report(
                name: "Project Performance", 
                type: .project, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            ),
            Report(
                name: "Staff Utilization", 
                type: .staff, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            ),
            Report(
                name: "Client Profitability", 
                type: .client, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            ),
            Report(
                name: "Invoice Summary", 
                type: .invoice, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            ),
            Report(
                name: "Payment Collection", 
                type: .payment, 
                template: "Activity by Project",
                owner: "Me",
                viewAccess: "Only me",
                isExpanded: false
            )
        ]
    }
}
