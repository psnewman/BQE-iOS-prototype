import SwiftUI
import UIKit

// Your other imports remain the same

@main
struct BQEApp: App {
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()

    // Create a gradient layer
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor(red: 0.02, green: 0.08, blue: 0.23, alpha: 1.0).cgColor,
      UIColor(red: 0.35, green: 0.23, blue: 0.25, alpha: 1.0).cgColor,
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

    // Use screen width and exact navigation bar height
    let size = CGSize(width: UIScreen.main.bounds.width, height: 98)
    gradientLayer.frame = CGRect(origin: .zero, size: size)

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    if let context = UIGraphicsGetCurrentContext() {
      gradientLayer.render(in: context)
      if let gradientImage = UIGraphicsGetImageFromCurrentImageContext() {
        UIGraphicsEndImageContext()

        // Set the gradient image as the background
        appearance.backgroundImage = gradientImage
      }
    }

    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }

  var body: some Scene {
    WindowGroup {
      // ContentView()
      TimerView()
      // ReportCenterView()
    }
  }
}
