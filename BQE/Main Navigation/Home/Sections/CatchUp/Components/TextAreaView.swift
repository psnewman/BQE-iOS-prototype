//
//  TextAreaView.swift
//  BQE
//
//  Created by Paul Newman on 12/13/24.
//

import SwiftUI

struct TextAreaView: View {
    let label: String
    let placeholder: String

    @Binding var text: String

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
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.border, lineWidth: 1))
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
                
                

        }
    }
}

#Preview {
    @Previewable @State var text = ""
    TextAreaView(label: "Memo", placeholder: "Enter memo", text: $text)
}
