# Pixel Style Redesign

## Overview
Transform the "私人管家" Flutter app from Material 3 to a retro pixel art / 8-bit game aesthetic with Evangelion Unit-01 color palette.

## Color Palette (EVA Unit-01 inspired)
| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#6A0DAD` | Buttons, app bar, active states, chips |
| `primaryDark` | `#3A0050` | Button pressed state |
| `accent` | `#00FF41` | Highlights, income, nav selected, border light |
| `income` | `#00FF41` | Income amounts |
| `expense` | `#FF4500` | Expense amounts |
| `background` | `#0A0A0A` | CRT dark background (near black) |
| `backgroundLight` | `#1A1A2E` | Slightly lighter bg (deep navy-purple) |
| `textPrimary` | `#FFFFFF` | Primary text on dark |
| `textSecondary` | `#888888` | Secondary text on dark |
| `textDark` | `#0A0A0A` | Text on light surfaces |
| `borderLight` | `#00FF41` | Neon green highlight border (raised) |
| `borderDark` | `#3A0050` | Deep purple shadow border (recessed) |
| `error` | `#FF0000` | Error / EVA red |
| `success` | `#00FF41` | Same as accent |
| `warning` | `#FF4500` | Same as expense |

## Typography
- Latin/numeric: `Press Start 2P` (via google_fonts)
- Chinese: System font fallback (no suitable pixel Chinese font available as dependency)

## UI Component Design
- **All radii = 0** — pixel-perfect corners
- **3px borders** — light on top/left, dark on bottom/right (raised 3D pixel effect)
- **Buttons**: Raised block with 3px pixel border, purple primary
- **Text fields**: Inset block (inverted borders), dark background
- **Cards**: Raised block with 3px pixel border, deep navy-purple surface
- **Dialogs**: Pixel-styled with chunky buttons
- **Bottom nav**: Pixel tab bar, neon green selected
- **AppBar**: Dark background with green text

## Effects
- CRT scanline overlay (repeating horizontal transparent lines)
- Dark CRT background (#0A0A0A) with subtle vignette
- Random subtle flicker animation

## File Changes

### Modified files
- `pubspec.yaml` — add `google_fonts` dependency
- `lib/core/constants/app_colors.dart` — EVA Unit-01 color palette
- `lib/core/constants/app_dimensions.dart` — remove radii, pixel grid
- `lib/core/theme/app_theme.dart` — complete pixel theme rewrite
- `lib/core/widgets/app_button.dart` — pixel-style button
- `lib/core/widgets/app_text_field.dart` — pixel-style text field
- `lib/core/widgets/empty_state.dart` — pixel empty state
- `lib/core/widgets/confirm_dialog.dart` — pixel dialog
- `lib/core/widgets/loading_overlay.dart` — pixel loading
- `lib/presentation/pages/splash/splash_page.dart` — pixel splash screen
- `lib/presentation/pages/home/main_shell.dart` — pixel bottom nav

### New files
- `lib/core/widgets/pixel_container.dart` — reusable pixel border decorator
- `lib/core/widgets/crt_overlay.dart` — CRT scanline + vignette + flicker
