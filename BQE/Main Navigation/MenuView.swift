//
//  MenuView.swift
//  BQE
//
//  Created by Paul Newman on 19.10.2024.
//
//
import SwiftUI
import FASwiftUI
//
struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    var isExpanded: Bool = false
    let icon: String?
    var children: [MenuItem]?
}
//
struct MenuView: View {
    @State private var menuItems: [MenuItem] = [
        MenuItem(title: "Dashboard", icon: "gauge"),
        MenuItem(title: "Projects", icon: "briefcase", children: [
            MenuItem(title: "Projects", icon: "briefcase"),
            MenuItem(title: "Assets", icon: "files", children: [
                MenuItem(title: "To-Dos", icon: nil),
                MenuItem(title: "Notes", icon: nil),
                MenuItem(title: "Documents", icon: nil)
            ])
        ]),
        MenuItem(title: "Time & Expense", icon: "clock", children: [
            MenuItem(title: "Time Card", icon: "calendar"),
            MenuItem(title: "Time Entries", icon: "list-ul"),
            MenuItem(title: "Timers", icon: "stopwatch"),
            MenuItem(title: "Expense Entries", icon: "receipt"),
            MenuItem(title: "Review Time & Expenses", icon: "eye"),
            MenuItem(title: "Manage PTO", icon: "umbrella-beach"),
            MenuItem(title: "Trips", icon: "car"),
            MenuItem(title: "Visits", icon: "map-pin")
        ]),
        MenuItem(title: "Billing", icon: "file-invoice-dollar", children: [
            MenuItem(title: "Invoices", icon: "file-invoice"),
            MenuItem(title: "Payments", icon: "money-bill-wave")
        ]),
        MenuItem(title: "Accounting", icon: "calculator", children: [
            MenuItem(title: "General Journal", icon: "book"),
            MenuItem(title: "Checks", icon: "money-check"),
            MenuItem(title: "Payables", icon: "file-invoice", children: [
                MenuItem(title: "Purchase Orders", icon: nil),
                MenuItem(title: "Vendor Bills", icon: nil),
                MenuItem(title: "Credit Cards", icon: nil),
                MenuItem(title: "Bill Payments", icon: nil)
            ])
        ]),
        MenuItem(title: "Human Resources", icon: "users", children: [
            MenuItem(title: "Benefits", icon: "award"),
            MenuItem(title: "Reviews", icon: "file-user"),
            MenuItem(title: "Journals", icon: "book"),
            MenuItem(title: "Incidents", icon: "siren-on")
        ]),
        MenuItem(title: "CRM", icon: "handshake", children: [
            MenuItem(title: "Sales", icon: "chart-bar", children: [
                MenuItem(title: "Follow-Ups", icon: nil),
                MenuItem(title: "Leads", icon: nil),
                MenuItem(title: "Prospects", icon: nil),
                MenuItem(title: "Opportunities", icon: nil),
                MenuItem(title: "Quotes", icon: nil),
                MenuItem(title: "Proposals", icon: nil)
            ]),
            MenuItem(title: "Campaigns", icon: "megaphone"),
            MenuItem(title: "Resource Library", icon: "book")
        ]),
        MenuItem(title: "Contacts", icon: "address-book", children: [
            MenuItem(title: "Employees", icon: "user-tie"),
            MenuItem(title: "Clients", icon: "user"),
            MenuItem(title: "Vendors", icon: "truck")
        ]),
        MenuItem(title: "Reports", icon: "chart-pie"),
        MenuItem(title: "Calendar (2)", icon: "calendar"),
        MenuItem(title: "Messages (10)", icon: "envelope"),
        MenuItem(title: "Help", icon: "circle-question")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                        MenuItemView(item: item, depth: 0)
                        
                        if item.title == "Reports" || item.title == "Messages (10)" {
                            Divider().background(.divider)
                                .padding(.vertical, 8)
                        }
                    }
                }
                .padding(16)
                
            }
        }
        .background(.masterBackground)
    }
    
}

struct MenuItemView: View {
    @State var item: MenuItem
    let depth: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if let iconName = item.icon {
                    FAText(iconName: iconName, size: 18)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.typographySecondary)
                }
                Text(item.title)
                    .bodyStyle()
                Spacer()
                if item.children != nil && !item.children!.isEmpty {
                    FAText(iconName: "chevron-down", size: 12)
                        .foregroundColor(.typographySecondary)
                        .rotationEffect(.degrees(item.isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: item.isExpanded)
                }
            }
            .padding(.leading, CGFloat(depth * 20))
            .frame(height: 44)
            .onTapGesture {
                if item.children != nil && !item.children!.isEmpty {
                    item.isExpanded.toggle()
                } else {
                    navigateToDetail(for: item)
                }
            }
            
            if item.isExpanded {
                ForEach(item.children ?? []) { child in
                    MenuItemView(item: child, depth: depth + 1)
                }
            }
        }
    }
    
    private func navigateToDetail(for item: MenuItem) {
        print("Navigating to \(item.title)")
    }
}
//
#Preview {
    MenuView()
}
