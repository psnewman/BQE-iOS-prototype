import SwiftUI
import FASwiftUI

struct TripRowView: View {
    let tripName: String
    let timeFrame: String
    let date: String
    let mileage: String
    let cost: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon - using Font Awesome route icon
            FAText(iconName: "fa-route", size: 16)
                .foregroundColor(.typographySecondary)
                .frame(width: 24, height: 24)
            
            // Trip information - left column
            VStack(alignment: .leading, spacing: 4) {
                // Trip name
                Text(tripName)
                    .bodyStyle()
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                
                // Trip details row
                HStack(spacing: 4) {
                    // Date
                    Text(date)
                        .bodySmallStyle()
                        .foregroundColor(.typographySecondary)
                    
                    // Bullet separator
                    Text("•")
                        .bodySmallStyle()
                        .foregroundColor(.typographySecondary)
                    
                    // Time frame
                    Text(timeFrame)
                        .bodySmallStyle()
                        .foregroundColor(.typographySecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Right column with mileage and cost
            VStack(alignment: .trailing, spacing: 4) {
                // Mileage with bold styling
                Text(mileage)
                    .bodyBoldStyle()
                    .foregroundColor(.typographyPrimary)
                
                // Cost
                Text(cost)
                    .bodyBoldStyle()
                    .foregroundColor(.typographySecondary)
            }
        }
        .padding(.vertical, 12)
//        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack (spacing: 0) {
        TripRowView(
            tripName: "Marvin Fort to West Springfield",
            timeFrame: "7:36 PM - 8:07 PM",
            date: "Feb 12",
            mileage: "12 miles",
            cost: "$123.45"
        )
        
        TripRowView(
            tripName: "Client Meeting in Boston",
            timeFrame: "3:15 PM - 4:45 PM",
            date: "Feb 15",
            mileage: "45 miles",
            cost: "$267.89"
        )
    }
}
