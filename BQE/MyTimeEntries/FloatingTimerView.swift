//
//  TimerView.swift
//  BQE
//
//  Created by Paul Newman on 6/4/25.
//

import FASwiftUI
import SwiftUI

struct FloatingTimerView: View {
  @State private var isExpanded: Bool = true

  var body: some View {
    VStack {
      HStack {
        if isExpanded {
          Text("Active Timers")
            .headlineStyle()
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }

        if isExpanded {
          Spacer()
          Button {
            withAnimation {
              isExpanded = false
            }
          } label: {
            HStack {
              FAText(iconName: "xmark", size: 16, style: .solid)
                .foregroundColor(.typographySecondary)
            }
            .padding(4)
          }
          .transition(.move(edge: .trailing).combined(with: .opacity))
        }
      }

      VStack(alignment: .leading, spacing: 8) {
        VStack(alignment: .leading, spacing: 4) {
          if isExpanded {
            VStack(alignment: .leading, spacing: 4) {
              Text("Design: 3D Modeling")
                .bodyBoldStyle()
                .foregroundColor(.typographyPrimary)
              HStack(spacing: 4) {
                Text("19-34 - Aspen Cultural Center")
                  .bodySmallStyle()
                  .foregroundColor(.typographyPrimary)
                Text("/")
                  .bodySmallStyle()
                  .foregroundColor(.typographyPrimary)
                Text("Schematic Design")
                  .bodySmallStyle()
                  .foregroundColor(.typographyPrimary)
              }
            }
            .padding(.bottom, 8)
            .transition(
              .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
              )
            )
          }

          HStack(alignment: .center) {
            HStack {
              if isExpanded {
                HStack {
                  FAText(
                    iconName: "pause",
                    size: 16,
                    style: .solid
                  )
                  .foregroundColor(.typographyPrimary)
                }
                .frame(width: 32, height: 32)
                .background(Color.yellow)
                .cornerRadius(8)
                //                .transition(.move(edge: .trailing).combined(with: .opacity))
                .transition(.opacity)
              }

              Button {
                withAnimation {
                  isExpanded = true
                }
              } label: {
                HStack {
                  Text("00:00:00")
                    .bodyStyle()
                    .foregroundColor(.typographyPrimary)
                }
                .padding(.horizontal, 8)
                .frame(maxHeight: 32)
                .background(Color.yellow)
                .cornerRadius(8)
              }
            }

            if isExpanded {
              Spacer()
              HStack(alignment: .center, spacing: 16) {
                HStack(spacing: 0) {
                  HStack {
                    FAText(
                      iconName: "flag-checkered",
                      size: 16,
                      style: .solid
                    )
                  }
                  .frame(width: 32, height: 32)
                  .background(Color.clear)
                  .cornerRadius(8)

                  HStack(alignment: .center) {
                    Text("Finalize")
                      .bodyStyle()
                  }
                  .frame(maxHeight: 32)
                }
                .foregroundColor(.masterPrimary)

                HStack {
                  FAText(
                    iconName: "ellipsis",
                    size: 16,
                    style: .solid
                  )
                  .foregroundColor(.typographyPrimary)
                }
                .frame(width: 32, height: 32)
                .background(Color.clear)
                .cornerRadius(8)
              }
              .transition(
                .asymmetric(
                  insertion: .move(edge: .trailing).combined(
                    with: .opacity
                  ),
                  removal: .move(edge: .leading).combined(
                    with: .opacity
                  )
                )
              )
            }
          }
        }
      }
      .padding(isExpanded ? 16 : 4)
      .background(.white)
      .overlay(
        RoundedRectangle(cornerRadius: isExpanded ? 8 : 12)
          .stroke(Color.yellow, lineWidth: 2)
      )
      .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 8 : 12))
      .clipped()

      HStack {
        if isExpanded {
          HStack {
            Text("Hide floating timer")
              .bodyStyle()
              .foregroundStyle(.masterPrimary)
          }
          .frame(maxHeight: 32)
          .transition(.move(edge: .trailing).combined(with: .opacity))

          if isExpanded {
            Spacer()
            Button {
              // Button action
            } label: {
              Text("View My Time Entries")
                .bodyStyle()
                .foregroundStyle(.masterPrimary)
            }
            .buttonStyle(.plain)
            .frame(maxHeight: 32)
            .padding(.horizontal, 12)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.masterPrimary, lineWidth: 1)
            )

            .transition(.move(edge: .leading).combined(with: .opacity))

          }
        }
      }
      .padding(.top, isExpanded ? 16 : 0)

    }
    .padding(.horizontal, isExpanded ? 12 : 4)
    .padding(.vertical, isExpanded ? 16 : 4)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 8 : 16))
    .shadow(
      color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.05),
      radius: 3,
      x: 0,
      y: 4
    )
    .shadow(
      color: Color(red: 0.06, green: 0.09, blue: 0.16).opacity(0.1),
      radius: 8,
      x: 0,
      y: 12
    )
  }
}

#Preview {
  FloatingTimerView()
}
