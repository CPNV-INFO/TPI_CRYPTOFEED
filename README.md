# Guides
Suivre les instructions décrites ci-dessus pour pouvoir installer l'environnement

## Guide d'installation
#### Plugin Android Studio
- Lancer Android Studio
- Cliquer sur **File** -> **Settings**
- Naviguer vers **Plugins** -> Installer les plugins ``Flutter`` et ``Dart``

#### _Flutter_
Pour installer le SDK de Flutter, il y a deux façons de faire.
- Télécharger manuellement le SDK :
  - Aller sur https://docs.flutter.dev/get-started/install/windows#get-the-flutter-sdk
  - Cliquer sur **flutter_windows_3.0.1-stable.zip** (à noter que le **3.0.1** est la version actuelle de Flutter et qu'il faudra télécharger ce dossier à chaque nouvelle mise à jour si vous voulez toujours avoir Flutter à jour)
  - Extraire le zip et placer le dossier **flutter** à l'endroit souhaité
  - _(Optionnel)_ Ajouter le SDK à la variable d'environnement PATH
    - Rechercher dans Windows **environnement**
    - Ajouter le chemin complet vers le dossier **flutter/bin**
- Cloner le dépôt Flutter :
  - Naviguer à l'endroit souhaité
  - Ouvrir un invité de commande -> Taper la commande ``git clone https://github.com/flutter/flutter.git -b stable``
  - _(Optionnel)_ Ajouter le SDK à la variable d'environnement PATH
    - Rechercher dans Windows **environnement**
    - Ajouter le chemin complet vers le dossier **flutter/bin**

#### _Émulateur / Appareil Android physique_
L'application peut être lancée depuis un appareil **Android** physique branché par USB ou depuis un émulateur qui doit être installé.
Pour installer cet émulateur veuillez suivre les étapes suivantes :
- Lancer Android Studio -> Cliquer sur l'icône du **Device Manager** (en haut à droite) -> Cliquer sur **Create device**
- Choisir un modèle d'appareil (j'ai personnellement utilisé le **Pixel 5** mais on peut choisir un autre modèle) -> Cliquer sur **Next**
- Séléctionner une ou plusieurs versions d'Android que vous voulez émuler (pour mon cas : **Sv2 - API Level 32 - ABI x86_64**)
- Sous **Emulated Performance** -> Séléctionner **Hardware - GLES 2.0** afin d'activer l'accélération matérielle pour un émulateur plus performant (Android Studio peut également choisir automatiquement en fonction des caractéristiques du PC).
- Vérifier la configuration -> Cliquer sur **Next**
- Une fois que tout est installé -> Cliquer sur l'icône du **Device Manager** (en haut à droite) -> Cliquer sur l'icône **Run** -> L'émulateur se lance et est prêt à recevoir l'application.


## Guide de lancement
- Ouvrir le terminal Android Studio
- Ouvrir le fichier ``main.dart`` -> Cliquer sur l'icône **Run** en haut de la fenêtre ou avec la combinaison **Maj + F10**. Cela lancera l'application en mode Debug (toutes les actions seront visibles dans le terminal d'Android Studio avec les potentiels erreurs)

## Guide de debug
Flutter intègre des outils de debug par défaut. Pour débugger l'application il suffit de :
- Lancer le fichier ``main.dart`` en cliquant sur l'icône **Debug** en haut de la fenêtre ou avec la combinaison **Maj + F9**
- Vous pourrez alors utiliser l'application normalement et voir les erreurs ou ajouter des points d'arrêt sur la gauche du code
