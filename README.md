# code_space_client

## JSON serialization

Generate JSON serialization:
flutter pub run build_runner watch --delete-conflicting-outputs
flutter pub run build_runner build --delete-conflicting-outputs

## Flutter Intl

Extension for VS Code: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl
Initialize Intl: CRTL + SHIFT + P -> Flutter Intl: Initialize
Add new locale: CRTL + SHIFT + P -> Flutter Intl: Add locale

- Flutter Intl extension only works if system have flutter installed globally. So don't forget to add C:\Users\<user>\fvm\default\bin to system path.
- Use intl extension version 1.18.2 instead of newest version because in newest version it generate messages_all.dart file with SynchronousFuture instead of Future.value and it cause error login screen always show in 1 second when start app.

## Fix fvm command is not working

- Delete fvm folder inside project
- Run command below command to recreate fvm folder

```
fvm use <flutter_version>
```

## Update flutter version with fvm

- Delete .fvm and .dart_tool folder inside project
- Run command fvm use <flutter_version>

```

## syncfusion_flutter_pdfviewer

When deploying to web, follow the instructions at "Web integration" section:
https://pub.dev/packages/syncfusion_flutter_pdfviewer
```
