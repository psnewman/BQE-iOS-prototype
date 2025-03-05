//
//  TextAreaView.swift
//  BQE
//
//  Created by Paul Newman on 12/13/24.
//

import SwiftUI
import FASwiftUI

struct EntryMemoRowView: View {
    @ObservedObject var card: EntryItem
    @ObservedObject var stackViewModel: CardStackViewModel
    @Binding var isMemoSheetPresented: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack {
                Text("Memo")
                    .foregroundColor(.typographySecondary)
                    .bodyStyle()
                
                if !card.memo.isEmpty {
                    Button(action: {
                        isMemoSheetPresented = true
                    }) {
                        FAText(iconName: "pen-to-square", size: 16)
                            .foregroundColor(.masterPrimary)
                    }
                }
            }
            .frame(width: 96, alignment: .leading)

            if card.memo.isEmpty {
                HStack {
                    Button(action: {
                        isMemoSheetPresented = true
                    }) {
                        Text("+ Add Memo")
                            .foregroundColor(.masterPrimary)
                            .bodyStyle()
                    }
                    Spacer()
                }
            } else {
                HStack {
                    Text(card.memo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.typographyPrimary)
                        .bodyStyle()
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }        
    }
}




#Preview {
    EntryMemoRowView(
        card: EntryItem(
            entryType: .expense,
            entryName: "Test Entry",
            description: "Test Description",
            memo: "",
            date: "1/1/2025",
            resource: "Test Resource",
            project: "Test Project",
            client: "Test Client",
            units: "1.00",
            costRate: "$100.00",
            costAmount: "$100.00",
            billRate: "$100.00",
            billable: .billable
        ),
        stackViewModel: CardStackViewModel(),
        isMemoSheetPresented: .constant(false)
    )
}
