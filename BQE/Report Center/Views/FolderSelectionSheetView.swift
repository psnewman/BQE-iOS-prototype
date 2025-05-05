import SwiftUI
import FASwiftUI

struct FolderSelectionSheetView: View {
    @Binding var selectedFolder: String
    let folders: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.masterPrimary)

                Text("Select Folder")
                    .headlineStyle()
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

                Button("Cancel") {}
                    .opacity(0)
            }
            .padding(16)

            List(folders, id: \.self) { folder in
                Button(action: {
                    selectedFolder = folder
                    dismiss()
                }) {
                    HStack {
                        Text(folder)
                            .bodyStyle()
                            .foregroundColor(.typographyPrimary)
                        
                        Spacer()
                        
                        if selectedFolder == folder {
                            FAText(iconName: "check", size: 14, style: .regular)
                                .foregroundColor(.masterPrimary)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    FolderSelectionSheetView(selectedFolder: .constant("All"), folders: ["All", "Favorites", "Recent"])
}
