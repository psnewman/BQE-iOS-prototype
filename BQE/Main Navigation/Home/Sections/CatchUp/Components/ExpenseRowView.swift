import SwiftUI

enum ExpenseRowLayout {
    case horizontal
    case vertical
}

struct ExpenseRowView: View {
    let label: String
    let value: String
    let layout: ExpenseRowLayout
    
    var body: some View {
        Group {
            switch layout {
            case .horizontal:
                    HStack(alignment: .top, spacing: 8) {
                        Text(label)
                            .foregroundColor(.typographySecondary)
                            .bodyStyle()
                            .frame(width: 96, alignment: .leading)
                        Spacer()
                        Text(value)
                            .foregroundColor(.typographyPrimary)
                            .bodyStyle()
                            .frame(maxWidth: .infinity, alignment: .leading)                    
                }
            case .vertical:
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text(value)
                        .font(.subheadline)
                }
            }
        }
    }
}
