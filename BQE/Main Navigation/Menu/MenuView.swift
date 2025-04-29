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
            // If item has children, show expander and handle tap
            if item.children != nil && !item.children!.isEmpty {
                HStack {
                    menuItemContent
                    Spacer()
                    expanderIcon
                }
                .padding(.leading, CGFloat(depth * 20))
                .frame(height: 44)
                .contentShape(Rectangle()) // Make entire HStack tappable
                .onTapGesture {
                    item.isExpanded.toggle()
                }
            } else {
                // If item has no children, use NavigationLink
                NavigationLink(destination: destinationView(for: item)) {
                    HStack {
                        menuItemContent
                        Spacer()
                    }
                    .padding(.leading, CGFloat(depth * 20))
                    .frame(height: 44)
                }
                .buttonStyle(.plain) // Use plain style to avoid default button appearance
            }

            if item.isExpanded {
                ForEach(item.children ?? []) { child in
                    MenuItemView(item: child, depth: depth + 1)
                }
            }
        }
    }

    // Helper view for the main content of the menu item (icon + text)
    private var menuItemContent: some View {
        HStack(spacing: 12) { // Add spacing between icon and text
            if let iconName = item.icon {
                FAText(iconName: iconName, size: 18, style: .light) // Use light style as per memory
                    .frame(width: 20, alignment: .center)
                    .foregroundColor(.typographySecondary)
            } else {
                // Add placeholder for alignment if no icon
                Spacer().frame(width: 20)
            }
            Text(item.title)
                .bodyStyle()
                .foregroundColor(.typographyPrimary) // Ensure text color is standard
        }
    }

    // Helper view for the expander icon
    private var expanderIcon: some View {
        FAText(iconName: "chevron-down", size: 12)
            .foregroundColor(.typographySecondary)
            .rotationEffect(.degrees(item.isExpanded ? 0 : -90)) // Correct rotation
            .animation(.easeInOut(duration: 0.2), value: item.isExpanded)
    }

    // Determine the destination view based on the item
    @ViewBuilder
    private func destinationView(for item: MenuItem) -> some View {
        // TODO: Add navigation destinations for other items
        switch item.title {
        case "Reports":
            ReportCenterView()
                .navigationTitle(item.title)
        case "Time Card":
            TimeCardView()
                .navigationTitle(item.title)
        default:
            Text("Navigate to \(item.title)") // Placeholder
                .navigationTitle(item.title)
        }
    }
}

//
#Preview {
    MenuView()
}
