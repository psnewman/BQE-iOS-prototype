# Time Card Screen Implementation Plan

This document outlines the steps to implement the Time Card screen based on the Figma design and discussions.

## Figma Design

Use Figma MCP server to access the design.

https://www.figma.com/design/eAH71zmf2oKxIhMrw6SXTK/BQE-iOS-App?node-id=23270-38563&t=xrl6RoogonWRPUOA-11

## Implementation Steps

1.  **Data Models:**
    *   Define `TimeCardProjectEntry` and `DailyHours` structs in `BQE/TimeCard/Models/`.
    *   `TimeCardProjectEntry`: `id: UUID`, `title: String`, `subtitle: String`, `dailyHours: [DailyHours]`
    *   `DailyHours`: `id: UUID`, `day: String`, `hours: Double`

2.  **Main View (`TimeCardView.swift`):**
    *   Create `BQE/TimeCard/Views/TimeCardView.swift`.
    *   Use `NavigationStack`.
    *   Set navigation title to "Time Card".
    *   Add placeholder trailing navigation bar buttons (Filter, Add, More).
    *   Use a `ScrollView` wrapping a main `VStack`.
    *   Apply `.masterBackground`.

3.  **Week Picker (`WeekPickerView.swift`):**
    *   Create `BQE/TimeCard/Views/WeekPickerView.swift`.
    *   Structure: `HStack` (padding: `0px 16px`, gap: `8px`) containing back arrow (`Image`), date range (`Text`), forward arrow (`Image`), "Today" (`Text`/`Button`).
    *   Styling: `bodyBoldStyle()` for date range, `bodyStyle()` for "Today". Colors: `typographyPrimary`, `masterPrimary`. Add bottom border (`1px`, `Color("divider")`).

4.  **Weekdays Header (`WeekdaysHeaderView.swift`):**
    *   Create `BQE/TimeCard/Views/WeekdaysHeaderView.swift`.
    *   Structure: `HStack` (padding: `8px 16px 16px`) containing 7 `VStack`s (padding: `0px 8px`, gap: `8px`). Each `VStack` has day name (`Text`) and date (`Text`).
    *   Styling: `bodySmallStyle()` and `bodySmallBoldStyle()`. Color: `typographyPrimary`.

5.  **Resource Picker:**
    *   Add a `Picker` or custom dropdown within `TimeCardView`.
    *   Structure: `HStack` (padding: `0px 12px`, gap: `8px`).
    *   Styling: `bodyStyle()`. Colors: `typographySecondary` (label), `typographyPrimary` (value). Border: `1px`, `Color("border")`, radius `8px`.

6.  **Time Card Row (`TimeCardRowView.swift`):**
    *   Create `BQE/TimeCard/Views/TimeCardRowView.swift`.
    *   Structure:
        *   Outer `VStack` (padding: `0px 16px`).
        *   Inner `VStack` (background: `masterBackground`, border: `Color("border")`, corner radius: `12px`).
        *   Header `HStack` (padding: `8px 12px`, gap: `12px`, background: `cardSecondary`, top corner radius: `8px`, bottom border: `Color("divider")`). Contains `VStack` for title/subtitle.
        *   Cells `HStack` (spacing: `0`). Contains 7 cell views.
        *   Cell View: `VStack`/`Text` (padding: `20px 14px`, border: `Color("divider")`). Handle first/last cell bottom corner radii (`8px`).
    *   Styling: Header title `bodyBoldStyle()`, subtitle `bodySmallStyle()`. Cell text `bodySmallStyle()`. Color: `typographyPrimary`.

7.  **List Integration:**
    *   In `TimeCardView`, add `WeekPickerView`, `WeekdaysHeaderView`, Resource Picker.
    *   Use `ForEach` within the `ScrollView`'s `VStack` (spacing: `16px`) to display `TimeCardRowView` instances using sample data.

8.  **Total Toolbar (`TimeCardTotalBarView.swift`):**
    *   Create `BQE/TimeCard/Views/TimeCardTotalBarView.swift`.
    *   Structure: `HStack` (padding: `8px 8px 8px 16px`, gap: `10px`).
    *   Styling: Background `masterBackground`, border `Color("border")`, shadow, corner radius `12px`.
    *   Content: `Text` ("Weekly total: ...") and `Button` ("Submit All").
    *   Button Styling: Height `32px`, padding `0px 12px`, border `Color("masterPrimary")`, text `bodyStyle()` `Color("masterPrimary")`, background `masterBackground`, corner radius `8px`.

9.  **Toolbar Integration:**
    *   Add `TimeCardTotalBarView` to `TimeCardView` using `.safeAreaInset(edge: .bottom)`.

10. **State Management:**
    *   Introduce `@State` variables or a ViewModel (`@StateObject`/`@ObservedObject`) in `TimeCardView` for selected week, resource, and `[TimeCardProjectEntry]` data.
    *   Connect UI elements to the state. Replace sample data.

11. **Final Polish:**
    *   Review against Figma for pixel-perfect matching (paddings, colors, fonts, interactions).
    *   Test responsiveness.

12. **To-Do List:**
    *   [x] Define `TimeCardProjectEntry` and `DailyHours` structs in `BQE/TimeCard/Models/`.
    *   [x] Create `BQE/TimeCard/Views/TimeCardView.swift`.
    *   [x] Create `BQE/TimeCard/Views/WeekPickerView.swift`.
    *   [x] Create `BQE/TimeCard/Views/WeekdaysHeaderView.swift`.
    *   [x] Add Resource Picker to `TimeCardView`.
    *   [x] Create `BQE/TimeCard/Views/TimeCardRowView.swift`.
    *   [ ] Integrate `WeekPickerView`, `WeekdaysHeaderView`, and Resource Picker in `TimeCardView`.
    *   [ ] Create `BQE/TimeCard/Views/TimeCardTotalBarView.swift`.
    *   [ ] Integrate `TimeCardTotalBarView` in `TimeCardView`.
    *   [ ] Implement state management in `TimeCardView`.
    *   [ ] Review and test the implementation.
