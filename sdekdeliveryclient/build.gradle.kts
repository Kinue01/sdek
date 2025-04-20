import kotlin.script.experimental.jvm.util.classpathFromFQN

// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.google.android.libraries.mapsplatform.secrets.gradle.plugin) apply false
    alias(libs.plugins.androidx.navigation.safeargs.gradle.plugin) apply false
}

dependencies {
    classpathFromFQN(ClassLoader.getSystemClassLoader(), "androidx.navigation:navigation-safe-args-gradle-plugin:2.8.8")
}