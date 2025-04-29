import Foundation

extension Date {
  var startOfWeek: Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
    return calendar.date(from: components)!
  }
}
