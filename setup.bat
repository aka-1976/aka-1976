@echo off
echo Setting up Android project...

echo Creating project structure...
mkdir app\src\main\java\com\example\aka1976\ui\theme
mkdir app\src\main\res\drawable
mkdir app\src\main\res\layout
mkdir app\src\main\res\mipmap-anydpi-v26
mkdir app\src\main\res\values
mkdir app\src\main\res\xml

echo Creating build.gradle (project level)...
(
echo buildscript {
echo     ext {
echo         compose_ui_version = '1.5.4'
echo         kotlin_version = '1.9.10'
echo     }
echo     repositories {
echo         google()
echo         mavenCentral()
echo     }
echo     dependencies {
echo         classpath 'com.android.tools.build:gradle:8.1.2'
echo         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:^$kotlin_version"
echo     }
echo }
echo.
echo plugins {
echo     id 'com.android.application' version '8.1.2' apply false
echo     id 'com.android.library' version '8.1.2' apply false
echo     id 'org.jetbrains.kotlin.android' version '1.9.10' apply false
echo }
echo.
echo task clean(type: Delete) {
echo     delete rootProject.buildDir
echo }
) > build.gradle

echo Creating app\build.gradle...
(
echo plugins {
echo     id 'com.android.application'
echo     id 'org.jetbrains.kotlin.android'
echo }
echo.
echo android {
echo     namespace 'com.example.aka1976'
echo     compileSdk 34
echo.
echo     defaultConfig {
echo         applicationId "com.example.aka1976"
echo         minSdk 24
echo         targetSdk 34
echo         versionCode 1
echo         versionName "1.0"
echo.
echo         testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
echo         vectorDrawables {
echo             useSupportLibrary true
echo         }
echo     }
echo.
echo     buildTypes {
echo         release {
echo             minifyEnabled false
echo             proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
echo         }
echo     }
echo     compileOptions {
echo         sourceCompatibility JavaVersion.VERSION_1_8
echo         targetCompatibility JavaVersion.VERSION_1_8
echo     }
echo     kotlinOptions {
echo         jvmTarget = '1.8'
echo     }
echo     buildFeatures {
echo         compose true
echo     }
echo     composeOptions {
echo         kotlinCompilerExtensionVersion '1.5.3'
echo     }
echo     packagingOptions {
echo         resources {
echo             excludes += '/META-INF/{AL2.0,LGPL2.1}'
echo         }
echo     }
echo }
echo.
echo dependencies {
echo     implementation 'androidx.core:core-ktx:1.12.0'
echo     implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.2'
echo     implementation 'androidx.activity:activity-compose:1.8.0'
echo.
echo     // Compose
echo     implementation platform('androidx.compose:compose-bom:2023.10.01')
echo     implementation 'androidx.compose.ui:ui'
echo     implementation 'androidx.compose.ui:ui-graphics'
echo     implementation 'androidx.compose.ui:ui-tooling-preview'
echo     implementation 'androidx.compose.material3:material3'
echo.
echo     // AdMob
echo     implementation 'com.google.android.gms:play-services-ads:22.5.0'
echo.
echo     // Test dependencies
echo     testImplementation 'junit:junit:4.13.2'
echo     androidTestImplementation 'androidx.test.ext:junit:1.1.5'
echo     androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
echo     androidTestImplementation platform('androidx.compose:compose-bom:2023.10.01')
echo     androidTestImplementation 'androidx.compose.ui:ui-test-junit4'
echo     debugImplementation 'androidx.compose.ui:ui-tooling'
echo     debugImplementation 'androidx.compose.ui:ui-test-manifest'
echo }
) > app\build.gradle

echo Creating settings.gradle...
echo include ':app' > settings.gradle

echo Creating gradle.properties...
(
echo org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
echo android.useAndroidX=true
echo android.enableJetfinder=true
) > gradle.properties

echo Creating MyApplication.kt...
(
echo package com.example.aka1976
echo.
echo import android.app.Application
echo import android.content.Context
echo import android.content.SharedPreferences
echo import com.google.android.gms.ads.AdRequest
echo import com.google.android.gms.ads.MobileAds
echo import com.google.android.gms.ads.appopen.AppOpenAd
echo import java.util.Calendar
echo import java.util.concurrent.TimeUnit
echo.
echo private const val AD_DISMISS_INTERVAL_HOURS = 1L
echo private const val MAX_PER_DAY = 3
echo.
echo private const val PREFS_NAME = "ad_prefs"
echo private const val LAST_DISMISS_KEY = "last_dismissed_at"
echo private const val DAY_START_KEY = "day_start_timestamp"
echo private const val TODAY_COUNT_KEY = "today_count"
echo.
echo class MyApplication : Application() {
echo.
echo     private var appOpenAd: AppOpenAd? = null
echo     private lateinit var prefs: SharedPreferences
echo.
echo     override fun onCreate() {
echo         super.onCreate()
echo         MobileAds.initialize(this) {}
echo         prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
echo     }
echo.
echo     fun showAdIfAvailable(activity: MainActivity) {
echo         if (appOpenAd != null && wasDismissedLongEnoughAgo() && canShowAdToday()) {
echo             appOpenAd?.fullScreenContentCallback = object :
echo                 com.google.android.gms.ads.FullScreenContentCallback() {
echo                 override fun onAdDismissedFullScreenContent() {
echo                     appOpenAd = null
echo                     recordAdDismissal()
echo                     loadAppOpenAd()
echo                 }
echo.
echo                 override fun onAdShowedFullScreenContent() {
echo                     // Called when ad is shown.
echo                 }
echo.
echo                 override fun onAdFailedToShowFullScreenContent(adError: com.google.android.gms.ads.AdError) {
echo                     // Called when ad fails to show.
echo                 }
echo             }
echo             activity.runOnUiThread {
echo                 appOpenAd?.show(activity)
echo             }
echo         } else {
echo             loadAppOpenAd()
echo         }
echo     }
echo.
echo     private fun recordAdDismissal() {
echo         val editor = prefs.edit()
echo         editor.putLong(LAST_DISMISS_KEY, System.currentTimeMillis())
echo         editor.putInt(TODAY_COUNT_KEY, prefs.getInt(TODAY_COUNT_KEY, 0) + 1)
echo         editor.apply()
echo     }
echo.
echo     private fun wasDismissedLongEnoughAgo(): Boolean {
echo         val lastDismissed = prefs.getLong(LAST_DISMISS_KEY, 0)
echo         val now = System.currentTimeMillis()
echo         return TimeUnit.MILLISECONDS.toHours(now - lastDismissed) >= AD_DISMISS_INTERVAL_HOURS
echo     }
echo.
echo     private fun canShowAdToday(): Boolean {
echo         val now = System.currentTimeMillis()
echo         val calendar = Calendar.getInstance()
echo         calendar.timeInMillis = now
echo         calendar.set(Calendar.HOUR_OF_DAY, 0)
echo         calendar.set(Calendar.MINUTE, 0)
echo         calendar.set(Calendar.SECOND, 0)
echo         calendar.set(Calendar.MILLISECOND, 0)
echo         val todayStart = calendar.timeInMillis
echo.
echo         val savedDay = prefs.getLong(DAY_START_KEY, 0)
echo.
echo         if (todayStart > savedDay) {
echo             prefs.edit()
echo                 .putLong(DAY_START_KEY, now)
echo                 .putInt(TODAY_COUNT_KEY, 0)
echo                 .apply()
echo             return true
echo         }
echo.
echo         val todayCount = prefs.getInt(TODAY_COUNT_KEY, 0)
echo         return todayCount < MAX_PER_DAY
echo     }
echo.
echo     private fun loadAppOpenAd() {
echo         val request = AdRequest.Builder().build()
echo.
echo         AppOpenAd.load(
echo             this,
echo             adUnitId,
echo             request,
echo             AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT,
echo             object : AppOpenAd.AppOpenAdLoadCallback() {
echo                 override fun onAdLoaded(ad: AppOpenAd) {
echo                     appOpenAd = ad
echo                 }
echo.
echo                 override fun onAdFailedToLoad(loadAdError: com.google.android.gms.ads.LoadAdError) {
echo                     // Handle error
echo                 }
echo             }
echo         )
echo     }
echo }
) > app\src\main\java\com\example\aka1976\MyApplication.kt

echo Creating MainActivity.kt...
(
echo package com.example.aka1976
echo.
echo import android.os.Bundle
echo import androidx.activity.ComponentActivity
echo import androidx.activity.compose.setContent
echo import androidx.compose.foundation.layout.fillMaxSize
echo import androidx.compose.material3.MaterialTheme
echo import androidx.compose.material3.Surface
echo import androidx.compose.material3.Text
echo import androidx.compose.runtime.Composable
echo import androidx.compose.ui.Modifier
echo import androidx.compose.ui.tooling.preview.Preview
echo import com.example.aka1976.ui.theme.Aka1976Theme
echo.
echo class MainActivity : ComponentActivity() {
echo     override fun onCreate(savedInstanceState: Bundle?) {
echo         super.onCreate(savedInstanceState)
echo         setContent {
echo             Aka1976Theme {
echo                 // A surface container using the 'background' color from the theme
echo                 Surface(
echo                     modifier = Modifier.fillMaxSize(),
echo                     color = MaterialTheme.colorScheme.background
echo                 ) {
echo                     Greeting("Android")
echo                 }
echo             }
echo         }
echo.
echo         (application as? MyApplication)?.showAdIfAvailable(this)
echo     }
echo }
echo.
echo @Composable
echo fun Greeting(name: String, modifier: Modifier = Modifier) {
echo     Text(
echo         text = "Hello ^$name!",
echo         modifier = modifier
echo     )
echo }
echo.
echo @Preview(showBackground = true)
echo @Composable
echo fun GreetingPreview() {
echo     Aka1976Theme {
echo         Greeting("Android")
echo     }
echo }
) > app\src\main\java\com\example\aka1976\MainActivity.kt

echo Creating AndroidManifest.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"
echo     xmlns:tools="http://schemas.android.com/tools"^>
echo.
echo     ^<uses-permission android:name="android.permission.INTERNET"/^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/^>
echo.
echo     ^<application
echo         android:name=".MyApplication"
echo         android:allowBackup="true"
echo         android:dataExtractionRules="@xml/data_extraction_rules"
echo         android:fullBackupContent="@xml/backup_rules"
echo         android:icon="@mipmap/ic_launcher"
echo         android:roundIcon="@mipmap/ic_launcher_round"
echo         android:supportsRtl="true"
echo         android:theme="@style/Theme.Aka1976"
echo         tools:targetApi="31"^>
echo         ^<activity
echo             android:name=".MainActivity"
echo             android:exported="true"
echo             android:theme="@style/Theme.Aka1976"^>
echo             ^<intent-filter^>
echo                 ^<action android:name="android.intent.action.MAIN" /^>
echo.
echo                 ^<category android:name="android.intent.category.LAUNCHER" /^>
echo             ^</intent-filter^>
echo         ^</activity^>
echo.
echo         ^<meta-data
echo             android:name="com.google.android.gms.ads.APPLICATION_ID"
echo             android:value="ca-app-pub-3940256099942544~3347511713"/^>
echo.
echo     ^</application^>
echo.
echo ^</manifest^>
) > app\src\main\AndroidManifest.xml

echo Creating Color.kt...
(
echo package com.example.aka1976.ui.theme
echo.
echo import androidx.compose.ui.graphics.Color
echo.
echo val Purple80 = Color(0xFFD0BCFF)
echo val PurpleGrey80 = Color(0xFFCCC2DC)
echo val Pink80 = Color(0xFFEFB8C8)
echo.
echo val Purple40 = Color(0xFF6650a4)
echo val PurpleGrey40 = Color(0xFF625b71)
echo val Pink40 = Color(0xFF7D5260)
) > app\src\main\java\com\example\aka1976\ui\theme\Color.kt

echo Creating Theme.kt...
(
echo package com.example.aka1976.ui.theme
echo.
echo import android.app.Activity
echo import android.os.Build
echo import androidx.compose.foundation.isSystemInDarkTheme
echo import androidx.compose.material3.MaterialTheme
echo import androidx.compose.material3.darkColorScheme
echo import androidx.compose.material3.dynamicDarkColorScheme
echo import androidx.compose.material3.dynamicLightColorScheme
echo import androidx.compose.material3.lightColorScheme
echo import androidx.compose.runtime.Composable
echo import androidx.compose.runtime.SideEffect
echo import androidx.compose.ui.graphics.toArgb
echo import androidx.compose.ui.platform.LocalContext
echo import androidx.compose.ui.platform.LocalView
echo import androidx.core.view.WindowCompat
echo.
echo private val DarkColorScheme = darkColorScheme(
echo     primary = Purple80,
echo     secondary = PurpleGrey80,
echo     tertiary = Pink80
echo )
echo.
echo private val LightColorScheme = lightColorScheme(
echo     primary = Purple40,
echo     secondary = PurpleGrey40,
echo     tertiary = Pink40
echo.
echo     /* Other default colors to override
echo     background = Color(0xFFFFFBFE),
echo     surface = Color(0xFFFFFBFE),
echo     onPrimary = Color.White,
echo     onSecondary = Color.White,
echo     onTertiary = Color.White,
echo     onBackground = Color(0xFF1C1B1F),
echo     onSurface = Color(0xFF1C1B1F),
echo     */
echo )
echo.
echo @Composable
echo fun Aka1976Theme(
echo     darkTheme: Boolean = isSystemInDarkTheme(),
echo     // Dynamic color is available on Android 12+
echo     dynamicColor: Boolean = true,
echo     content: @Composable () -> Unit
echo ) {
echo     val colorScheme = when {
echo         dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
echo             val context = LocalContext.current
echo             if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
echo         }
echo.
echo         darkTheme -> DarkColorScheme
echo         else -> LightColorScheme
echo     }
echo     val view = LocalView.current
echo     if (!view.isInEditMode) {
echo         SideEffect {
echo             val window = (view.context as Activity).window
echo             window.statusBarColor = colorScheme.primary.toArgb()
echo             WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = darkTheme
echo         }
echo     }
echo.
echo     MaterialTheme(
echo         colorScheme = colorScheme,
echo         typography = Typography,
echo         content = content
echo     )
echo }
) > app\src\main\java\com\example\aka1976\ui\theme\Theme.kt

echo Creating Type.kt...
(
echo package com.example.aka1976.ui.theme
echo.
echo import androidx.compose.material3.Typography
echo import androidx.compose.ui.text.TextStyle
echo import androidx.compose.ui.text.font.FontFamily
echo import androidx.compose.ui.text.font.FontWeight
echo import androidx.compose.ui.unit.sp
echo.
echo // Set of Material typography styles to start with
echo val Typography = Typography(
echo     bodyLarge = TextStyle(
echo         fontFamily = FontFamily.Default,
echo         fontWeight = FontWeight.Normal,
echo         fontSize = 16.sp,
echo         lineHeight = 24.sp,
echo         letterSpacing = 0.5.sp
echo     )
echo     /* Other default text styles to override
echo     titleLarge = TextStyle(
echo         fontFamily = FontFamily.Default,
echo         fontWeight = FontWeight.Normal,
echo         fontSize = 22.sp,
echo         lineHeight = 28.sp,
echo         letterSpacing = 0.sp
echo     ),
echo     labelSmall = TextStyle(
echo         fontFamily = FontFamily.Default,
echo         fontWeight = FontWeight.Medium,
echo         fontSize = 11.sp,
echo         lineHeight = 16.sp,
echo         letterSpacing = 0.5.sp
echo     )
echo     */
echo )
) > app\src\main\java\com\example\aka1976\ui\theme\Type.kt

echo Creating ic_launcher_background.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<vector xmlns:android="http://schemas.android.com/apk/res/android"
echo     android:width="108dp"
echo     android:height="108dp"
echo     android:viewportWidth="108"
echo     android:viewportHeight="108"^>
echo     ^<path
echo         android:fillColor="#3DDC84"
echo         android:pathData="M0,0h108v108h-108z" /^>
echo ^</vector^>
) > app\src\main\res\drawable\ic_launcher_background.xml

echo Creating ic_launcher_foreground.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<vector xmlns:android="http://schemas.android.com/apk/res/android"
echo     android:width="108dp"
echo     android:height="108dp"
echo     android:viewportWidth="108"
echo     android:viewportHeight="108"^>
echo     ^<path
echo         android:fillColor="#00000000"
echo         android:pathData="M48.5,23.5L48.5,84.5"
echo         android:strokeWidth="1"
echo         android:strokeColor="#3DDC84"
echo         android:strokeLineCap="round"
echo         android:strokeLineJoin="round" /^>
echo     ^<path
echo         android:fillColor="#00000000"
echo         android:pathData="M23.5,48.5L84.5,48.5"
echo         android:strokeWidth="1"
echo         android:strokeColor="#3DDC84"
echo         android:strokeLineCap="round"
echo         android:strokeLineJoin="round" /^>
echo ^</vector^>
) > app\src\main\res\drawable\ic_launcher_foreground.xml

echo Creating ic_launcher.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android"^>
echo     ^<background android:drawable="@drawable/ic_launcher_background" /^>
echo     ^<foreground android:drawable="@drawable/ic_launcher_foreground" /^>
echo ^</adaptive-icon^>
) > app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml

echo Creating ic_launcher_round.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android"^>
echo     ^<background android:drawable="@drawable/ic_launcher_background" /^>
echo     ^<foreground android:drawable="@drawable/ic_launcher_foreground" /^>
echo ^</adaptive-icon^>
) > app\src\main\res\mipmap-anydpi-v26\ic_launcher_round.xml

echo Creating colors.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo     ^<color name="purple_200"^>#FFBB86FC^</color^>
echo     ^<color name="purple_500"^>#FF6200EE^</color^>
echo     ^<color name="purple_700"^>#FF3700B3^</color^>
echo     ^<color name="teal_200"^>#FF03DAC5^</color^>
echo     ^<color name="teal_700"^>#FF018786^</color^>
echo     ^<color name="black"^>#FF000000^</color^>
echo     ^<color name="white"^>#FFFFFFFF^</color^>
echo ^</resources^>
) > app\src\main\res\values\colors.xml

echo Creating strings.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo     ^<string name="app_name"^>aka-1976^</string^>
echo ^</resources^>
) > app\src\main\res\values\strings.xml

echo Creating themes.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo.
echo     ^<style name="Theme.Aka1976" parent="android:Theme.Material.Light.NoActionBar" /^>
echo ^</resources^>
) > app\src\main\res\values\themes.xml

echo Creating data_extraction_rules.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo     ^<data-extraction-rules^>
echo         ^<cloud-backup^>
echo             ^<exclude domain="sharedpref" path="."/^>
echo         ^</cloud-backup^>
echo     ^</data-extraction-rules^>
echo ^</resources^>
) > app\src\main\res\xml\data_extraction_rules.xml

echo Creating backup_rules.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<resources^>
echo     ^<full-backup-content^>
echo         ^<exclude domain="sharedpref" path="."/^>
echo     ^</full-backup-content^>
echo ^</resources^>
) > app\src\main\res\xml\backup_rules.xml

echo Project setup complete.
echo You can now open the project in Android Studio.
echo.
pause
