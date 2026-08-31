# PARTIX — Claymorphism + Animation Redesign

**Goal:** poori app ko **Claymorphism** design mein badalna + **har jagah animation**
(inspiration: `reactbits.dev` & `vengenceui.com`).

> All new/changed Dart files pass `dart format` (syntax verified). The package
> already depends on `flutter_animate`, so all animations work out of the box.

---

## ✅ What's done

### 1. Clay design system (new files)
| File | What |
|------|------|
| `lib/core/constants/clay_palette.dart` | Pastel clay colour tokens (light + dark + accents + blob colours) |
| `lib/shared/widgets/clay.dart` | **`ClayContainer`** (the clay primitive: big radius, outer drop + inner highlight/shade, press-squish, 3D tilt), **`ClayCard`**, **`ClayColors`** (theme-aware), **`clayShadows()`** |

### 2. Animation toolkit (new file, reactbits/vengenceui inspired)
`lib/shared/widgets/clay_animations.dart`:
- **`Magnetic`** — element pulls toward the pointer (vengenceui "hover/glow/press")
- **`TiltCard`** — 3D tilt that follows the cursor
- **`FlipText`** — rotating words with vertical flip reveal (vengenceui "flip-text")
- **`ShimmerText`** — iridescent shimmer sweeping across text
- **`StaggeredReveal`** — children fade+slide in one-by-one
- **`Spotlight`** — radial light that tracks the pointer (vengenceui "spotlight")
- **`ClayBlobBackground`** — drifting, morphing clay blobs (reactbits "soft aurora" in clay tones)

### 3. Themes → clay
- `light_theme.dart`, `dark_theme.dart` — pastel clay backgrounds, clay surfaces,
  `InkSparkle` splash, clay inputs/buttons/bottom-nav.

### 4. Core shared surfaces → clay (auto-converts the whole app)
- **`glass.dart`** — `GlassCard` / `GlassPill` / `TapScale` now render **clay** while
  keeping the same API. Since `GlassCard` is used across the dashboard + menu, the
  conversion propagates everywhere automatically.
- `custom_button.dart` — clay button with **magnetic pull + glow + light sweep +
  press squish + haptics + morphing loading state**.
- `section_card.dart`, `partix_bottom_nav.dart` (clay floating bar), `partix_app_bar.dart` (clay).

### 5. Flagship screens fully redesigned
- **Splash** — clay logo puck with 3D tilt, shimmer wordmark, flip-text tagline,
  sweeping progress bar on animated clay blobs.
- **Login** — magnetic clay hero, shimmer wordmark, flip-text tagline, spotlight
  glow on the clay card, animated lockout notice.
- **Dashboard** — animated clay blob background.

---

## 🔧 What remains (next steps)

These screens still use raw `Container` surfaces (they still work, but keep the old
glassy style and need conversion for full clay consistency):

- **Team** — `team_screen`, `team_member_card`, `team_stats_header`, `team_list_view`,
  `tree_view_widget`, `tree_node_widget`, `member_detail_screen`
- **Earnings** — `earnings_detail_screen`, `earnings_type_card`, `earnings_transaction_item`,
  `level_breakdown_table`, `period_selector_bar`
- **Withdrawal** — `withdrawal_screen`, `balance_header_card`, `amount_input_widget`,
  `payment_method_selector`, `withdrawal_history_card`, `withdrawal_history_screen`
- **Profile** — `profile_screen`, `profile_header_widget`, `personal_info_section`,
  `bank_details_section`, `upi_details_section`, `app_settings_section`, `security_section`
- **Notifications** — `notifications_screen`
- **Dashboard widgets** — `earning_metric_card`, `earnings_chart_widget`,
  `rank_progress_card`, `quick_actions_row`, `recent_activity_list`
- **Shared** — `app_menu_sheet`, `custom_text_field`, `loading_overlay`, `success_overlay`,
  `empty_state_widget`, `error_state_widget`, `shimmer_card`, `partix_loader`, `animated_logo`

The recommended approach for the remaining screens is the same pattern already in
place: swap raw `Container` surfaces for `ClayContainer`/`ClayCard`, and add
`StaggeredReveal` / `TiltCard` / `Magnetic` / `FlipText` to lists and headers.

---

## 🎨 How to use the new building blocks

```dart
// A clay card
ClayCard(title: 'My Team', child: child);

// A pressable, tiltable clay surface
ClayContainer(pressable: true, tilt: true, onTap: () {}, child: child);

// Magnetic + tilt on any widget
Magnetic(child: TiltCard(child: myButton));

// Animated background
ClayBlobBackground(cycleSeconds: 16, child: content);
```
