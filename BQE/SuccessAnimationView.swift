//
//  SuccessAnimationView.swift
//  BQE
//
//  Created by Paul Newman on 12/3/24.
//

import SwiftUI
import RiveRuntime

struct SuccessAnimationView: View {
    var body: some View {
        RiveViewModel(fileName: "Checkmark Icon").view()
    }
}

#Preview {
    SuccessAnimationView()
}
