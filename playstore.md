# Synap Play Store Submission Checklist

Last updated: 2026-03-17

4K master rule:
- Create all creative assets in 4K first (recommended 3840 x 2160 canvas), then export Play Store upload sizes.
- Final upload sizes must still follow Google requirements exactly.

1. AAB File
- Status: DONE
- File: build/app/outputs/bundle/release/app-release.aab

2. App Icon 512 x 512
- Status: DONE
- Recommended file: web/icons/Icon-512.png

3. Feature Graphic (Banner) 1024 x 500
- Status: MISSING
- Action: Design in 4K master, then export exact 1024 x 500 PNG/JPG to assets/store/feature-graphic-1024x500.png

4. Screenshots (9:16 ratio)
- Status: MISSING
- Action: Capture/edit in high resolution, then export at least 2 screenshots in 1080 x 1920 or higher (strict 9:16) to assets/store/screenshots/

5. Short Description (max 80 chars)
- Status: READY
- Suggested: Discover 1200+ AI tools and chat with a smart voice assistant.

6. Long Description (max 4000 chars)
- Status: READY
- Source: play_store_metadata.md

7. Privacy Policy
- Status: DONE
- URL: https://synap-ac981.web.app/

8. Demo Login Details
- Status: READY
- Note: App supports guest mode. For reviewer instructions, use: Open app -> Continue as Guest.

9. Play Console Account
- Status: IN PROGRESS
- Action: Finish Data safety form, Content rating, and App access in Play Console.

## Immediate Next Steps

1. Prepare one feature graphic (1024 x 500).
2. Prepare minimum 2 phone screenshots (9:16).
3. Upload AAB + privacy URL + descriptions.
4. Complete Data safety and Content rating sections.

## QC Command

Run this before upload:
- powershell -NoProfile -ExecutionPolicy Bypass -File scripts/check_store_assets.ps1
