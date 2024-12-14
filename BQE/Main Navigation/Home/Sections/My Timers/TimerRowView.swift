//
//  TimerRowView.swift
//  BQE
//
//  Created by Paul Newman on 11/11/24.
//

import SwiftUI

struct TimerRowView: View {
    
    
    @State private var isActive: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var isAnimating: Bool = false
    let clientName: String?
    let projectDetails: String?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
                    
        HStack {
            HStack(spacing: 8) {
                PlayIconView(isActive: isActive)
                    .scaleEffect(isAnimating ? 0.75 : 1.0)
                    .animation(.interpolatingSpring(stiffness: 500, damping: 20), value: isAnimating)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isActive.toggle()
                        }
                        isAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            isAnimating = false
                        }
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(clientName ?? "N/A")
                        .lineLimit(1)
                        .bodyStyle()
                        .foregroundColor(.typographyPrimary)
                    Text(projectDetails ?? "N/A")
                        .lineLimit(1)
                        .bodySmallStyle()
                        .foregroundColor(.typographySecondary)
                }
            }
            
            Spacer()
            
            Text(formattedElapsedTime)
                .font(.custom("Inter", size: 14, relativeTo: .body))
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundColor(.typographyPrimary)
        }
        .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64)
//        .background(Color.clear)
        .onReceive(timer) { _ in
            if isActive {
                elapsedTime += 1
            }
        }
    }
    
    private var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


struct PlayIconView: View {
    let isActive: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isActive ? Color.masterBackground : Color(red: 0.98, green: 0.75, blue: 0.14))
                .stroke(Color(red: 0.98, green: 0.75, blue: 0.14), lineWidth: 2)
                .frame(width: 32, height: 32)
            
            if !isActive {
                PlayIcon()
                    .fill(.white)
                    .frame(width: 14, height: 16)
                    .offset(x: 1)
            } else {
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.98, green: 0.75, blue: 0.14))
                        .frame(width: 4, height: 14)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.98, green: 0.75, blue: 0.14))
                        .frame(width: 4, height: 14)
                }
            }
        }
        
    }
}

struct PlayIcon: Shape {
        func path(in rect: CGRect) -> Path {
                var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                let cornerRadius: CGFloat = 2

                path.move(to: CGPoint(x: cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: width - cornerRadius, y: height / 2 - cornerRadius))
                path.addQuadCurve(to: CGPoint(x: width, y: height / 2),
                                  control: CGPoint(x: width, y: height / 2 - cornerRadius))
                path.addQuadCurve(to: CGPoint(x: width - cornerRadius, y: height / 2 + cornerRadius),
                                  control: CGPoint(x: width, y: height / 2 + cornerRadius))
                path.addLine(to: CGPoint(x: cornerRadius, y: height))
                path.addQuadCurve(to: CGPoint(x: 0, y: height - cornerRadius),
                                  control: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0),
                                  control: CGPoint(x: 0, y: 0))
                path.closeSubpath()

                return path
        }
}


#Preview {
    VStack {
        TimerRowView(
            clientName: "Client Meeting",
            projectDetails: "19-08 - PASADENA: Design Development"
        )
        TimerRowView(
            clientName: "Project Planning",
            projectDetails: "20-08 - SEATTLE: Initial Concepts"
        )
    }
}
