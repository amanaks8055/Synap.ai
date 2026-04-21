# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Supabase / Postgrest / Storage
-keep class io.github.jan.supabase.** { *; }
-keep class com.supabase.** { *; }

# Google Sign In
-keep class com.google.android.gms.auth.api.signin.** { *; }
-dontwarn com.google.android.gms.**

# AdMob
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep class  nodes.** { *; }

# Play Core (Fixes R8 error)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.internal.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn com.google.errorprone.annotations.**
