import SwiftUI
import FASwiftUI

struct VisitRowView: View {
    let visitName: String
    let timeFrame: String
    let date: String
    let duration: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon - using Font Awesome location-check icon
            FAText(iconName: "location-check", size: 16)
                .foregroundColor(.typographySecondary)
                .frame(width: 24, height: 24)
            
            // Visit information - left column
            VStack(alignment: .leading, spacing: 4) {
                // Visit name
                Text(visitName)
                    .bodyStyle()
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                
                // Visit details row
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
            
            // Right column with duration
            VStack(alignment: .trailing, spacing: 4) {
                // Duration with bold styling
                Text(duration)
                    .bodyBoldStyle()
                    .foregroundColor(.typographyPrimary)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack (spacing: 0) {
        VisitRowView(
            visitName: "Client Office in Downtown",
            timeFrame: "9:30 AM - 11:15 AM",
            date: "Mar 5",
            duration: "1.75 hrs"
        )
        
        VisitRowView(
            visitName: "Site Inspection at North End",
            timeFrame: "2:00 PM - 3:38 PM",
            date: "Mar 5",
            duration: "1.63 hrs"
        )
    }
}
