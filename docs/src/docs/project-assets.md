# Project Assets
In case you need to modify any of the project's assets, please refer to this document in order to avoid breaking anything inside the app.

## Fonts
The fonts used in the app are located insied `assets/fonts`. To use a new font inside the app, add the `.ttf` file(s) inside this folder and include it in the 
`pubspec.yaml` file. You can follow [this guide](https://flutter.dev/docs/cookbook/design/fonts) for more information on working with fonts inside a Flutter app.

## Launcher icons
In case you need to change the launcher icons for the app, you can use the [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) package.
It's already installed in the project, so all you need to do in order to generate a new launcher icon is the following:
1. Replace `launcher_icon.png` under `assets/images/` with the icon you want to use (make sure it's the same name and extension)
2. Open a terminal in the project's root directory and execute the following two commands:
```dart
flutter pub get
flutter pub run flutter_launcher_icons:main
```

## App icons
The icons used inside this app were provided as svg assets. However, using icons as fonts is more efficient and practical.  
For this reason, all these icons are placed under `assets/icons` and converted to a font file using the [Flutter Icon Font Generator](https://pub.dev/packages/icon_font_generator).

To add new icons, follow these steps:
1. Install the icon font generator package globally by running `flutter pub global activate icon_font_generator` 
2. Add the icon files to `assets/icons`, and make sure they are svg files that are named in a **snake_case** format.
3. Run the following command to regenerate the font file and the icons dart class:
   ```dart
   icon_font_generator --from=assets/icons --class-name=WadiGreenIcons --out-font=assets/fonts/wadi_green_icons.ttf --out-flutter=lib/utils/wadi_green_icons.dart
   ```

## Images
The images used inside the app are located under `assets/images`.   
In order to make the app easier to maintain, the image assets are not referenced as strings inside the app: every image location is declared as a
constant variable inside `lib/core/images.dart` and the variable is what's used in the app. By using this approach, images can be easily replaced or 
renamed without worrying about breaking anything in the app or forgetting to update a reference somewhere.

**Instead of using:**
```dart
Image.asset('assets/images/brand/logo.png');
```
**We use:**
```dart
Image.asset(BrandImages.logoPng);
```
where `BrandImages.logoPng` is declared inside `lib/core/images.dart`.  

**Note:** Make sure to also update `pubspec.yaml` When adding images to folders that are not already included in it. 