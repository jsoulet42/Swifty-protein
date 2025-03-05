// !!! IMPORTANT : NE MODIFIEZ CE FICHIER QUE SI VOUS SAVEZ CE QUE VOUS FAITES !!!
// Ce fichier de build Gradle de niveau racine configure les dépôts et la gestion globale du build.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    // !!! IMPORTANT : FORCEZ LA VERSION DU GROUPE "org.jetbrains.kotlin" POUR ASSURER LA COMPATIBILITÉ.
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "org.jetbrains.kotlin") {
                useVersion("2.1.0") // !!! IMPORTANT : VÉRIFIER ET METTRE À JOUR CETTE VERSION SI NÉCESSAIRE.
            }
        }
    }
}

// !!! IMPORTANT : NE MODIFIEZ PAS LES PARAMÈTRES CI-DESSOUS, A MOINS QUE VOUS NE SOYEZ SÛR.
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
