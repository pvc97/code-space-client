# code_space_client

## JSON serialization

Generate JSON serialization:
flutter pub run build_runner watch --delete-conflicting-outputs
flutter pub run build_runner build --delete-conflicting-outputs

## Flutter Intl

Extension for VS Code: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl
Initialize Intl: CRTL + SHIFT + P -> Flutter Intl: Initialize
Add new locale: CRTL + SHIFT + P -> Flutter Intl: Add locale

- Currently this extension is not working, so I have to add intl_utils package and use it to generate the files with command:

```
fvm flutter pub run intl_utils:generate
```

## Fix fvm command is not working

- Delete fvm folder inside project
- Run command below command to recreate fvm folder

```
fvm use <flutter_version>
```

## syncfusion_flutter_pdfviewer

When deploying to web, follow the instructions at "Web integration" section:
https://pub.dev/packages/syncfusion_flutter_pdfviewer
