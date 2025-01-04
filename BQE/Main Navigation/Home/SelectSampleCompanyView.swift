import SwiftUI

struct SelectSampleCompanyView: View {
    @Binding var selectedOption: String
    @Environment(\.dismiss) var dismiss
    let companies = ["Accounting", "Architectural", "Consulting", "Engineering", "Legal"]

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.masterPrimary)

                Text("Select Sample Company")
                    .headlineStyle()
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                Button("Cancel") {}
                    .opacity(0)
            }
            .padding(16)

            List(companies, id: \.self) { company in
                Button(action: {
                    selectedOption = company  // Update selectedOption directly
                    dismiss()
                }) {
                    Text(company)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    SelectSampleCompanyView(selectedOption: .constant("Accounting"))
}
