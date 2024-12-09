//
//  SuccessAnimationView.swift
//  BQE
//
//  Created by Paul Newman on 12/3/24.
//

import SwiftUI
import RiveRuntime

struct SuccessAnimationView: View {
    @StateObject private var successAnimation = RiveViewModel(
        fileName: "success",
        stateMachineName: "State Machine 1",
        autoPlay: false
    )
    
    @State private var isSuccess = false
    
    var body: some View {
        VStack(alignment: .center) {
            successAnimation.view()
                .frame(width: 300, height: 300)
            
            Button("Push Me") {
                isSuccess = true
                successAnimation.setInput("startSuccessAnimation", value: true)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SuccessAnimationView()
}
