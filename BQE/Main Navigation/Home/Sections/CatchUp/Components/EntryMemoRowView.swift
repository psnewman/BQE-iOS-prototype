//
//  TextAreaView.swift
//  BQE
//
//  Created by Paul Newman on 12/13/24.
//

import SwiftUI

struct EntryMemoRowView: View {
    let label: String
    let placeholder: String
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .frame(width: 96, alignment: .leading)
                .foregroundColor(.typographySecondary)
                .bodyStyle()
            Spacer()
            TextEditor(text: $text)
                .bodyStyle()
                .frame(height: 56)
                .padding(.horizontal, 8)
                .scrollContentBackground(.hidden)
                .foregroundColor(.typographyPrimary)
                .focused($isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? .masterPrimary : .border, lineWidth: 1)
                )
                .overlay(
                    Group {
                        if text.isEmpty {
                            Text(placeholder)
                                .bodyStyle()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 13)
                                .foregroundColor(.typographySecondary)
                        }
                    },
                    alignment: .topLeading
                )
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        if isFocused {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                            .foregroundStyle(.masterPrimary)
                        }
                    }
                }

        }
    }
}


#Preview {
    @Previewable @State var text = ""
    EntryMemoRowView(label: "Memo", placeholder: "Enter memo", text: $text)
}
