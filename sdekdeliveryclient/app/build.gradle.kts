import java.io.FileInputStream
import java.util.*

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.google.android.libraries.mapsplatform.secrets.gradle.plugin)
    alias(libs.plugins.androidx.navigation.safeargs.gradle.plugin)
}

var apiPropFile = rootProject.file("secret.properties")
var secretProperties = Properties()
secretProperties.load(FileInputStream(apiPropFile))

android {
    namespace = "com.example.myapplication"
    compileSdk = 35

    apply(plugin = "androidx.navigation.safeargs")

    defaultConfig {
        applicationId = "com.example.myapplication"
        minSdk = 34
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    defaultConfig {
        buildConfigField("String", "PROD_API_URL", "${secretProperties["PROD_API_URL"]}")
        buildConfigField("String", "DEV_API_URL", "${secretProperties["DEV_API_URL"]}")
        buildConfigField("String", "PROD_WS", "${secretProperties["PROD_WS"]}")
        buildConfigField("String", "DEV_WS", "${secretProperties["DEV_WS"]}")
        buildConfigField("String", "ESDB_PROD_URL", "${secretProperties["ESDB_PROD_URL"]}")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    packaging { resources.excludes.add("META-INF/versions/9/OSGI-INF/MANIFEST.MF") }
}

dependencies {
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    implementation(libs.annotation)
    implementation(libs.navigation.ui)
    implementation(libs.navigation.fragment)
    implementation(libs.play.services.location)
    implementation(libs.java.websocket)
    implementation(libs.gson)
    implementation(libs.okhttp)
    implementation(libs.jackson.databind)
    implementation(libs.retrofit)
    implementation(libs.converter.gson)
    implementation(libs.kurrentdb.client) {
        exclude(group = "com.google.api.grpc", module = "proto-google-common-protos")
    }

    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}