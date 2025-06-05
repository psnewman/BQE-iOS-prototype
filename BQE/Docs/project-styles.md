# Project Styles

This document lists the project's styles, including colors and text styles, with references to their definitions.

## Colors

The project uses colors defined in the `Colors.xcassets` file.

The following colors are available:

- alert:
  - Light: #DC2625
  - Dark: #EE4444
- border:
  - Light: #CBD5E1
  - Dark: #4C5065
- cardSecondary:
  - Light: #F1F4F9
  - Dark: #333542
- divider:
  - Light: #E1E8F0
  - Dark: #4C5065
- masterBackground:
  - Light: #FFFFFF
  - Dark: #23242D
- masterBackgroundSecondary:
  - Light: #F2F4FA
  - Dark: #333542
- masterBackgroundSelected:
  - Light: #F0F9FF
  - Dark: #0C4B6E
- masterPrimary: #399DEB
- navbarDropdownBackground:
  - Light: #E1E8F0
  - Dark: #344056
- tag:
  - tagGreenBackground:
    - Light: #DCFCE7
    - Dark: #166535
  - tagGreenBorder:
    - Light: #86EF86
    - Dark: #17A34A
  - tagGreenText:
    - Light: #157F3D
    - Dark: #BBF7D1
  - tagGreyBackground:
    - Light: #F1F4F9
    - Dark: #4C5065
  - tagGreyBorder:
    - Light: #CBD5E1
    - Dark: #9CA2AE
  - tagGreyText:
    - Light: #465568
    - Dark: #E1E8F0
  - tagRedBackground:
    - Light: #FEE1E2
    - Dark: #991B1C
  - tagRedBorder:
    - Light: #FBA5A4
    - Dark: #DC2625
  - tagRedText:
    - Light: #B81C1D
    - Dark: #FECBCB
- typographyPrimary:
  - Light: #000000
  - Dark: #FFFFFF
- typographySecondary:
  - Light: #8E8E93
  - Dark: #A3A3A3

Usage: Apply colors to views using the `.colorName` syntax, e.g., `.foregroundColor(.typographySecondary)`.

Reference: [`BQE/Colors.xcassets`](BQE/Colors.xcassets)

## Text Styles

The project uses typography styles defined in the `TextStyles.swift` file.

The following text styles are available:

- bodySmallStyle:
  - Font: Inter, size: 12, relativeTo: .caption
  - Weight: regular
  - Line Spacing: 4
- bodySmallBoldStyle:
  - Font: Inter, size: 12, relativeTo: .caption
  - Weight: bold
  - Line Spacing: 6
- bodyStyle:
  - Font: Inter, size: 14, relativeTo: .body
  - Weight: regular
  - Line Spacing: 6
- bodyBoldStyle:
  - Font: Inter, size: 14, relativeTo: .body
  - Weight: semibold
  - Line Spacing: 6
- headlineStyle:
  - Font: Inter, size: 16, relativeTo: .headline
  - Weight: semibold
  - Line Spacing: 8
- titleStyle:
  - Font: Inter, size: 24, relativeTo: .title
  - Weight: bold

Usage: Apply typography styles using the `.styleName()` syntax, e.g., `.bodyStyle()`.

Reference: [`BQE/Helpers/TextStyles.swift`](BQE/Helpers/TextStyles.swift)
