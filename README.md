[![pub package](https://img.shields.io/pub/v/flutter_daylight_savings.svg)](https://pub.dartlang.org/packages/flutter_daylight_savings)

## Flutter Daylight Savings

Get upcoming daylight savings transitions from the operating system

## No Dependencies

FlutterDaylightSavings has zero dependencies besides Flutter, Android, iOS, and MacOS themselves.

## Usage

```dart
var transitions = await FlutterDaylightSavings.getNextTransitions(count: 50);
```

## Example App

Enable the platforms you need.

```
cd ./example                      
flutter config --enable-macos-desktop                                                      
flutter config --enable-android 
flutter config --enable-ios 
flutter create .
flutter run
```

## ⭐ Stars ⭐

Please star this repo & on [pub.dev](https://pub.dev/packages/flutter_daylight_savings). We all benefit from having a larger community.



