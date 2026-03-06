allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Bloque de directorios: Lo mantenemos pero simplificado
// Flutter usa esto para que los archivos temporales no ensucien tu proyecto.
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Inyección para plugins que esperan la propiedad 'flutter' (ej. android_intent_plus)
    // Se define como propiedad de proyecto (extra) para compatibilidad con Groovy
    if (project.name != "app") {
        project.extensions.extraProperties.set("flutter", mapOf(
            "compileSdkVersion" to 34,
            "minSdkVersion" to 21,
            "targetSdkVersion" to 34,
            "ndkVersion" to "25.1.8937393"
        ))
        
        // Restauramos la dependencia de evaluación estándar de Flutter SOLO para plugins
        project.evaluationDependsOn(":app")
    }
}

// Bloque de fallback para settings de plugins para asegurar compatibilidad con AGP 8+
subprojects {
    project.plugins.withId("com.android.library") {
        val android = project.extensions.getByType(com.android.build.gradle.LibraryExtension::class.java)
        
        // Fallback para compileSdk si el plugin no lo define (evita errores de configuración)
        if (android.compileSdkVersion == null) {
            android.compileSdkVersion(34)
        }
        
        // Asegurar namespace si falta (requerido en AGP 8+)
        if (android.namespace == null) {
            android.namespace = "com.liebeblack.isla_digital.${project.name.replace("-", "_")}"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.add("-Xlint:-options")
        
        // Mejora para Linux: Usa múltiples procesos para compilar Java
        options.isIncremental = true
        options.isFork = true 
    }
}
