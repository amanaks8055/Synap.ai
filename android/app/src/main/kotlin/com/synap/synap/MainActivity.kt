package com.synap.synap

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.widget.Button

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register our custom native ad factory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "synapNativeAd",         // ← factoryId Flutter se match karo
            SynapNativeAdFactory(this)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "synapNativeAd")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}

// ══════════════════════════════════════════
//  Native Ad Factory
// ══════════════════════════════════════════
class SynapNativeAdFactory(private val context: Context) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String?, Any?>?
    ): NativeAdView {
        // Inflate our custom dark-themed layout
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_dark, null) as NativeAdView

        with(nativeAdView) {
            // Headline
            val headlineView = findViewById<TextView>(R.id.ad_headline)
            headlineView.text = nativeAd.headline
            this.headlineView = headlineView

            // Body text
            val bodyView = findViewById<TextView>(R.id.ad_body)
            if (nativeAd.body != null) {
                bodyView.text = nativeAd.body
                bodyView.visibility = View.VISIBLE
            } else {
                bodyView.visibility = View.GONE
            }
            this.bodyView = bodyView

            // Icon
            val iconView = findViewById<ImageView>(R.id.ad_icon)
            if (nativeAd.icon != null) {
                iconView.setImageDrawable(nativeAd.icon!!.drawable)
                iconView.visibility = View.VISIBLE
            } else {
                iconView.visibility = View.GONE
            }
            this.iconView = iconView

            // CTA Button
            val ctaView = findViewById<TextView>(R.id.ad_call_to_action)
            if (nativeAd.callToAction != null) {
                ctaView.text = nativeAd.callToAction
                ctaView.visibility = View.VISIBLE
            } else {
                ctaView.visibility = View.GONE
            }
            this.callToActionView = ctaView

            // Register NativeAd — important!
            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}
