import SwiftUI

enum EntryRowLayout {
    case horizontal
    case vertical

}

struct EntryTextRowView: View {
    let label: String
    let value: String
    let layout: EntryRowLayout
    let isDescription: Bool
    
    var body: some View {
        Group {
            switch layout {
            case .horizontal:
                HStack(alignment: .top, spacing: 8) {
                    Text(label)
                        .foregroundColor(.typographySecondary)
                        .bodyStyle()
                        .frame(width: 96, alignment: .leading)
                        
                    Text(value)                        
                        .foregroundColor(.typographyPrimary)
                        .bodyStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(isDescription ? 1 : 1, reservesSpace: isDescription)
                        .truncationMode(.tail)
                }
            case .vertical:
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .foregroundColor(.secondary)
                        .bodySmallStyle()
                    Text(value)
                        .bodyStyle()
                }           
            }
        }
    }
}

#Preview {
    EntryTextRowView(label: "Memo", value: "Memo text", layout: .horizontal, isDescription: true)
}
