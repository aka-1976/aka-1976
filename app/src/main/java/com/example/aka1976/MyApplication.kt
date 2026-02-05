package com.example.aka1976

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.appopen.AppOpenAd
import com.google.android.gms.ads.AdRequest
import java.util.concurrent.TimeUnit
import android.os.SystemClock

class MyApplication : Application() {
    
    private var appOpenAd: AppOpenAd? = null
    private val adUnitId = "ca-app-pub-2081353974363572/3153703253"
    private lateinit var prefs: SharedPreferences
    
    companion object {
        private const val PREFS_NAME = "AdPrefs"
        private const val LAST_AD_SHOWN_KEY = "last_ad_shown"
        private const val MIN_INTERVAL_HOURS = 4
        private const val MAX_PER_DAY = 3
        private const val DAY_START_KEY = "day_start"
        private const val TODAY_COUNT_KEY = "today_count"
    }
    
    override fun onCreate() {
        super.onCreate()
        prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        
        MobileAds.initialize(this) {
            if (shouldShowAppOpenAd()) {
                loadAppOpenAd()
            }
        }
    }
    
    private fun shouldShowAppOpenAd(): Boolean {
        val now = SystemClock.elapsedRealtime()
        val lastShown = prefs.getLong(LAST_AD_SHOWN_KEY, 0)
        val hoursSinceLastAd = TimeUnit.MILLISECONDS.toHours(now - lastShown)
        
        if (hoursSinceLastAd < MIN_INTERVAL_HOURS) return false
        
        val todayStart = prefs.getLong(DAY_START_KEY, 0)
        val currentDay = TimeUnit.MILLISECONDS.toDays(now)
        val savedDay = TimeUnit.MILLISECONDS.toDays(todayStart)
        
        if (currentDay != savedDay) {
            prefs.edit()
                .putLong(DAY_START_KEY, now)
                .putInt(TODAY_COUNT_KEY, 0)
                .apply()
            return true
        }
        
        val todayCount = prefs.getInt(TODAY_COUNT_KEY, 0)
        return todayCount < MAX_PER_DAY
    }
    
    private fun loadAppOpenAd() {
        val request = AdRequest.Builder().build()
        
        AppOpenAd.load(
            this,
            adUnitId,
            request,
            AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT,
            object : AppOpenAd.AppOpenAdLoadCallback() {
                override fun onAdLoaded(ad: AppOpenAd) {
                    appOpenAd = ad
                }
                
                override fun onAdFailedToLoad(loadAdError: com.google.android.gms.ads.LoadAdError) {
                    // Handle error
                }
            }
        )
    }
}
