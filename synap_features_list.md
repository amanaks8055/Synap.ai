# 🌟 Synap: Complete Feature List

Synap is a comprehensive Artificial Intelligence companion app that combines a conversational voice assistant with a massive directory of AI tools. Below is the complete list of features implemented in the application.

---

## 🎙️ 1. Intelligent Voice Assistant (Voice Hub)
*   **Speech-to-Text (STT):** Talk naturally to the app using device microphone integration.
*   **Text-to-Speech (TTS):** The AI reads out its responses in a natural-sounding voice.
*   **Real-time AI Chat:** Powered by advanced AI models to answer questions, brainstorm, and assist with tasks.
*   **Interactive UI:** Futuristic waveform animations and visual feedback during listening, thinking, and speaking states.
*   **Mode Switching:** Toggle between different conversational modes or AI personas.

## 🔍 2. AI Tools Discovery Engine
*   **Massive Directory:** A curated list of 1200+ AI tools across various industries (fetched from Supabase).
*   **Smart Categorization:** Tools are neatly organized into categories like:
    *   Writing & SEO
    *   Image Generation
    *   Video & Audio
    *   Coding & Development
    *   Business & Productivity
*   **Search Functionality:** Instantly search for specific tools by name or use case.
*   **Detailed Tool Profiles:** Each tool has a dedicated page showing its description, pricing model (Free, Freemium, Paid), and a direct link to the tool's website.

## ⭐ 3. Personalization & Favorites
*   **Save Favorites:** Users can bookmark their favorite AI tools for quick access later.
*   **Guest Mode Support:** Favorites are saved locally on the device for users who haven't logged in.
*   **Cloud Syncing:** Logged-in users have their favorites synced across devices via Supabase.

## 🔐 4. Authentication & User Profiles
*   **Multiple Sign-In Options:**
    *   Google Sign-In (One-tap auth)
    *   Email & Password (with Forgot Password functionality)
    *   Guest Mode (Try before you sign up)
*   **Profile Management:** View user details, manage subscriptions, and log out securely.

## 💎 5. Premium Subscription (In-App Purchases)
*   **Synap Premium:** A paid subscription tier offering enhanced features.
*   **Ad-Free Experience:** Removes all banner and native ads for a clean UI.
*   **Cross-Platform Sync:** Purchases are securely verified via Supabase Edge Functions, ensuring users retain their premium status across multiple devices.
*   **Restore Purchases:** Easily restore past subscriptions.

## 🎨 6. UI/UX & Theming
*   **Interstellar Theme:** A custom, premium dark-mode aesthetic with deep space backgrounds, glowing accents (cyan/purple), and glassmorphism effects.
*   **Light/Dark Mode Toggle:** Users can switch between dark and light themes dynamically based on preference.
*   **Responsive Design:** Optimized for both standard mobile displays and larger devices/tablets.
*   **Smooth Animations:** Fluid screen transitions, glowing borders, and loading indicators.

## 💰 7. Monetization (Free Tier)
*   **AdMob Integration:** Strategic, non-intrusive ad placements for free users.
*   **Banner Ads:** Displayed at the bottom of select screens.
*   **Native Inline Ads:** Seamlessly integrated into scrolling lists (like the Explore feed) to maintain a good user experience.

## ☁️ 8. Backend & Infrastructure
*   **Supabase Backend:** Utilizes Supabase for secure Authentication, Postgres Database (for tools and favorites), and Edge Functions (for secure receipt validation).
*   **Offline Resilience:** Graceful fallbacks and local storage usage (SharedPreferences) when the network is unstable.
*   **Usage Tracking:** Monitors user interactions to recommend better tools.
