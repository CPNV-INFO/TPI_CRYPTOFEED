# Guides
Suivre les instructions décrites ci-dessus pour pouvoir installer l'environnement

## Guide d'installation
#### Android Studio
- Aller sur https://developer.android.com/studio/
- Cliquer sur **Download Android Studio** (La version utilisée dans mon projet est la version **Chipmunk 2021.2.1** qui est la dernière version en date)

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

## Guide de debug
Note importante :

Pour pouvoir debugger la partie Authentification et Favoris, il faut pouvoir utiliser le Login avec Google. Cependant, il faut que la clé SHA1 de votre machine figure dans les paramètres de l'application Firebase, chose que vous ne pouvez pas faire vous-même. La console Firebase n'étant accessible qu'avec mon addresse Google personnelle.

Vous pouvez cependant tester l'application en l'état en buildant l'application en mode "Release". Pour se faire :
- Ouvrir le terminal Android Studio
- Taper la commande ``flutter run --release``

Vous ne pourrez donc pas debugger l'application ni faire de changements dans le code et voir les modifications en live.

Cependant, si vous voulez debugger la partie liste de Cryptos et liste de News, vous pouvez le faire sans problèmes étant donné que pour voir visualiser et naviguer dans ces listes, il n'y a pas besoin d'utiliser l'Authentification Google. Pour se faire :
- lancer le fichier ``main.dart`` en cliquant sur l'icône **Debug** en haut de la fenêtre ou avec la combinaison ``MAJ + F9``
