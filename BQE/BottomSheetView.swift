import SwiftUI

struct BottomSheetView: View {
    @Binding var selectedCompany: String // Non-optional String
    @Environment(\.dismiss) var dismiss // Access dismiss action
    let companies = ["Accounting", "Architectural", "Consulting", "Engineering", "Legal"]

    var body: some View {
        VStack {
            List(companies, id: \.self) { company in
                Button(action: {
                    selectedCompany = company // Update the selected company
                    dismiss() // Dismiss the sheet after selection
                }) {
                    Text(company)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Select Company")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss() // Dismiss the sheet on cancel
                }
            }
        }
        .onAppear {
            // Set the default appearance for the navigation bar in this view
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground() // Use the default background
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label] // Default text color
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

            // Apply the appearance to the navigation bar
            let navigationBar = UINavigationBar.appearance()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        .onDisappear {
            // Reset the appearance to the global custom one
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.02, green: 0.08, blue: 0.23, alpha: 1.0)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            // Restore the previous appearance
            let navigationBar = UINavigationBar.appearance()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    BottomSheetView(selectedCompany: .constant("Accounting"))
}
