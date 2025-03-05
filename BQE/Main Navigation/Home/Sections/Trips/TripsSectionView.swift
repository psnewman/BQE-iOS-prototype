import SwiftUI
import FASwiftUI

// Trip model
struct Trip: Identifiable {
    let id = UUID()
    let tripName: String
    let timeFrame: String
    let date: String
    let mileage: String
    let cost: String
}

struct TripsSectionView: View {
    @State private var trips = [
        Trip(
            tripName: "Marvin Fort to West Springfield",
            timeFrame: "7:36 PM - 8:07 PM",
            date: "Feb 12",
            mileage: "12 miles",
            cost: "$123.45"
        ),
        Trip(
            tripName: "Client Meeting in Boston",
            timeFrame: "3:15 PM - 4:45 PM",
            date: "Feb 15",
            mileage: "45 miles",
            cost: "$267.89"
        ),
        Trip(
            tripName: "Site Visit to Cambridge",
            timeFrame: "10:30 AM - 11:45 AM",
            date: "Feb 18",
            mileage: "28 miles",
            cost: "$156.20"
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(trips) { trip in
                    TripRowView(
                        tripName: trip.tripName,
                        timeFrame: trip.timeFrame,
                        date: trip.date,
                        mileage: trip.mileage,
                        cost: trip.cost
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteTrip(id: trip.id)
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
            .frame(height: CGFloat(trips.count * 64))
        }
        .background(Color.clear)
    }
    
    // Function to delete a trip
    private func deleteTrip(id: UUID) {
        if let index = trips.firstIndex(where: { $0.id == id }) {
            trips.remove(at: index)
        }
    }
}

#Preview {
    TripsSectionView()
}
