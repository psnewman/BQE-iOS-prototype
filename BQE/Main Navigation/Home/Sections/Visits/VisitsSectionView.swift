import SwiftUI
import FASwiftUI

// Visit model
struct Visit: Identifiable {
    let id = UUID()
    let visitName: String
    let timeFrame: String
    let date: String
    let duration: String
}

struct VisitsSectionView: View {
    @State private var visits = [
        Visit(
            visitName: "1234 Main Street, Boston, MA 02108",
            timeFrame: "9:30 AM - 11:15 AM",
            date: "Mar 5",
            duration: "1.75 hrs"
        ),
        Visit(
            visitName: "567 Washington Ave, Seattle, WA 98101",
            timeFrame: "2:00 PM - 3:38 PM",
            date: "Mar 5",
            duration: "1.63 hrs"
        ),
        Visit(
            visitName: "890 Broadway, New York, NY 10003",
            timeFrame: "10:00 AM - 11:30 AM",
            date: "Mar 8",
            duration: "1.50 hrs"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(visits) { visit in
                    VisitRowView(
                        visitName: visit.visitName,
                        timeFrame: visit.timeFrame,
                        date: visit.date,
                        duration: visit.duration
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteVisit(id: visit.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                        } label: {
                            Label("Time Entry", systemImage: "clock")
                        }
                        .tint(.masterPrimary)                        
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .frame(height: CGFloat(visits.count * 64))
        }
        .background(Color.clear)
    }
    
    // Function to delete a visit
    private func deleteVisit(id: UUID) {
        if let index = visits.firstIndex(where: { $0.id == id }) {
            visits.remove(at: index)
        }
    }
}

#Preview {
    VStack {
        VisitsSectionView()
    }
    .padding()
}
