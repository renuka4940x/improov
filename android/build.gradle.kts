plugins {
    id("com.google.gms.google-services") version "4.3.15" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    afterEvaluate {
        plugins.withType<com.android.build.gradle.BasePlugin> {
            extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
                if (namespace == null && project.name.contains("isar")) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }
    }
}