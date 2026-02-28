# Synap — AI Coding Rules 🛸

## Project Context
- **Framework**: Flutter with BLoC (Business Logic Component) pattern.
- **Backend**: Supabase (Auth, DB, Sync).
- **Design System**: "Dark Void" (Glassomorphism, Aurora effects).
- **Fonts**: Primary fonts are `Syne` (Headings) and `DM Sans` (Body), but can be changed or expanded based on specific features or aesthetic needs.
- **Brand Color**: `#00C8E8` (Synap Cyan).

## 🛡️ Critical Constraints (DO NOT BREAK)
- **Home Screen**: NEVER modify `lib/screens/home_screen.dart` directly without explicit permission.
- **Patterns**: Strict BLoC usage (Events -> States -> UI). No ad-hoc `setState` for global logic.
- **Folder Structure**: 
  - New screens: `lib/screens/`
  - New widgets: `lib/widgets/`
  - Data logic/Supabase: `lib/services/`
  - Models: `lib/models/`

## 🧠 Workflow Orchestration (AI Agent Mode)

### 1. Plan Node Default
- Deeply analyze requirements before writing a single line of code.
- Create a multi-step plan for any task requiring more than 3 steps.
- If a blocking error occurs, stop immediately and re-evaluate the plan.

### 2. Verification Before Done
- Run `flutter analyze` after every major change.
- Ensure no "unused imports" or "deprecated members" are left behind.
- Verify that fonts and colors strictly match the design system.

### 3. Core Principles
- **Simplicity First**: Write clean, readable code. Avoid over-engineering.
- **Accuracy**: Double-check Supabase table names (e.g., `extension_sync`) and keys.
- **Elite Aesthetics**: Every UI component must feel "Premium" (Gradients, Glows, Glass).

## 🐚 Synap-Specific Rules
- **Extension Sync**: Always ensure data from `payload` (JSONB) is mapped correctly to `TrackerTool` models.
- **Auth**: Always handle guest mode and logged-in states as distinct paths in `AuthService`.
- **Assets**: All icons/logos should favor SVG (`flutter_svg`) where possible.
