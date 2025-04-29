The BQE iOS prototype uses Font Awesome icons via the FASwiftUI package. To implement Font Awesome icons in Swift files:

1. Import the package at the top of the file:
```swift
import FASwiftUI
```

2. Use the FAText component to display icons. Example:
```swift
FAText(iconName: "icon-name", size: 20, style: .light)
    .foregroundColor(.typographySecondary)
```

Common parameters:
- iconName: The Font Awesome icon name (e.g., "stopwatch", "calendar-clock", "cart-circle-check")
- size: The size of the icon (typically 12-24)
- style: Font weight style (.light, .regular, .solid)
- foregroundColor: The color of the icon

Common icons used in the project:
- "stopwatch" - for timers
- "calendar-clock" - for time entries
- "cart-circle-check" - for expense entries
- "fa-route" - for trips
- "fa-gauge" - for dashboard
- "user-crown" - for clients
- "fa-briefcase" - for projects
- "magnifying-glass-dollar" - for review
- "chevron-right", "chevron-down" - for navigation indicators
- "pen-to-square" - for edit actions
- "fa-plus" - for add actions