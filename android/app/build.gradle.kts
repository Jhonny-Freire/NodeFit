plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.joaopedro.nodefit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Exigido pelo flutter_local_notifications (notificações agendadas).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // ID definitivo do app (docs/PLANO.md, 9.3). Não mude depois de
        // instalar a versão de uso real nem de registrar no Google.
        applicationId = "dev.joaopedro.nodefit"
        // 26: exigido pelo Health Connect (v0.4) e pelo ML Kit GenAI.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        manifestPlaceholders["appLabel"] = "NodeFit"
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        // `flutter run` instala um app SEPARADO ("NodeFit DEV", com dados
        // próprios): testar nunca apaga os treinos do app de uso real.
        debug {
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appLabel"] = "NodeFit DEV"
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
