//
//  MemoBottomSheet.swift
//  BQE
//
//  Created by Paul Newman on 12/23/24.
//

import SwiftUI

struct MemoBottomSheet: View {
  @Binding var isMemoSheetPresented: Bool
  @Binding var memo: String
  @FocusState private var isFocused: Bool
  @Environment(\.dismiss) private var dismiss

  var body: some View {

    VStack(spacing: 4) {

      HStack {
        Button("Cancel") {
          isMemoSheetPresented = false
          dismiss()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.masterPrimary)

        Spacer()

        Text("Memo")
          .headlineStyle()
          .frame(maxWidth: .infinity)

        Spacer()
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.vertical, 8)

      TextEditor(text: $memo)
        .frame(maxWidth: .infinity, minHeight: 80)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .tint(.masterPrimary)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(isFocused ? .masterPrimary : .border, lineWidth: 1)
        )
        .focused($isFocused)
        .onAppear {
          isFocused = true
        }
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") {
              isMemoSheetPresented = false
              isFocused = false
              dismiss()
            }
            .tint(.masterPrimary)
          }
        }

      Spacer()
    }
    .padding(16)
  }
}

#Preview {
  @Previewable @State var memo = "Test memo"
  @Previewable @State var isMemoSheetPresented = true
  MemoBottomSheet(isMemoSheetPresented: $isMemoSheetPresented, memo: $memo)
}
