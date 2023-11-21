# Lokale Mand Customer App Maintenance

# Running the App in the iOS Simulator

To run the app in the iOS Simulator, follow these steps:

1. **Install Flutter**: Ensure you have Flutter installed on your system. If you haven't installed
   Flutter yet, you can follow the instructions in the official Flutter
   documentation: [Installing Flutter](https://flutter.dev/docs/get-started/install).

2. **Install Xcode**: You need Xcode to run your Flutter app on the iOS Simulator. You can download
   Xcode from the Mac App Store or the Apple Developer website. Make sure it's installed and
   up-to-date.

3. **Set Up an iOS Simulator**:

    - Open Xcode.
    - From the Xcode menu, go to "Preferences."
    - Click on the "Components" tab.
    - Under "Simulators," click the "+" button to add an iOS simulator. Choose a device (e.g.,
      iPhone 11) and a version of iOS.
    - Click "Download" to install the selected simulator if it's not already installed.

4. **Navigate to Your Flutter Project**:

   Open your terminal or command prompt.

   ```shell
   cd path/to/your/flutter/project
   ```

5. **Open iOS Project in Xcode**:

    - Navigate to the `ios` directory within your Flutter project.

   ```shell
   cd ios
   ```

    - If you don't have a `.xcworkspace` file (for example, if you just cloned your project), you
      need to create one. Run:

   ```shell
   pod init
   ```

    - Open the iOS project in Xcode by running:

   ```shell
   open Runner.xcworkspace
   ```

6. **Set Up CocoaPods (if not already set up)**:

    - Initialize a `Podfile` for your project. If you've already done this, you can skip this step.

   ```shell
   pod init
   ```

    - Update your `Podfile` with the required dependencies.

    - Run:

   ```shell
   pod install
   ```

    - Update the dependencies (if needed).

   ```shell
   pod update
   ```

7. **Create an iOS Directory (if not already created)**:

    - If your Flutter project doesn't already have an `ios` directory, you can create it using the
      following command:

   ```shell
   flutter create .
   ```

8. **Select Target Device in Xcode**:

    - In Xcode, you will see the project open. In the top left corner of the Xcode window, you will
      see a target device dropdown. Click on it to select your iOS simulator or a connected physical
      iOS device.

9. **Build and Run the App**:

    - Click the "Run" button (a play icon) in the top-left corner of the Xcode window.
    - Alternatively, you can use the keyboard shortcut `Cmd+R` to initiate the build and run
      process.

10. **Wait for the App to Launch**: Xcode will build your Flutter app and launch it in the selected
    iOS Simulator. It may take a moment to compile and start the app.

11. **Interact with Your App**: Once the app is launched in the iOS Simulator, you can interact with
    it just like you would on a physical iOS device.

12. **Debug and Test**: You can use Xcode's debugging tools and Flutter DevTools to test and debug
    your app in the iOS Simulator.

This step-by-step guide should help you run your Flutter app in the iOS Simulator, including setting
up CocoaPods and creating an iOS directory if necessary. It's important to note that the names of
the iOS simulators and the specifics may vary depending on your Xcode and Flutter versions, so make
sure to adapt the instructions to your environment.
***

# Common Instructions

## Generate Keystore

Create a keystore for the app:

```shell
keytool -genkey -v -keystore keystore-lokale-mand.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

## Flutter Clean

### Clear Flutter Temp Files

To clear temporary files and clean the project:

```shell
flutter clean
```

### Clean and Get Dependencies

To clean the project and fetch dependencies:

```shell
flutter clean
flutter pub get
```

### Repair Pub Cache

To repair the pub cache:

```shell
flutter clean
flutter pub cache repair
flutter pub get
```

## Build Android Application

To build the Android application:

```shell
flutter clean
flutter pub get
flutter build apk --split-per-abi
```

## Build Android App Bundle

To build the Android app bundle:

```shell
flutter clean
flutter pub get
flutter build appbundle
```

## Update iOS Pods

Update iOS dependencies:

```shell
cd ios
pod init
pod install
pod update
cd ..
```

## Clear Derived Cache Data in iOS

To clear derived cache data in iOS:

```shell
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## Publish iOS App

### Publish Without Changing Version

To publish the iOS app without changing the version:

```shell
flutter clean
flutter pub get 
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod install 
pod update 
xed .
```

### Publish With Changing Version

To publish the iOS app with a version change:

```shell
flutter clean
flutter pub get 
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod install 
pod update 
flutter build ios
pod install 
pod update 
xed .
```

## Solve Common iOS Errors

To resolve common iOS errors:

```shell
flutter clean
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod deintegrate
flutter pub cache repair
flutter pub get 
pod install 
pod update 
flutter build ios
pod install 
pod update
xed .
```

## Clean Firebase Data and Cache

To clean old Firebase data and cache from the code:

```shell
rm -rf .metadata
rm -rf .flutter-plugins-dependencies
rm -rf .flutter-plugins
rm -rf .idea
rm -rf .dart_tool
rm -rf build
rm -rf android/app/google-services.json
rm -rf android/.gradle
rm -rf ios/.symlinks
rm -rf ios/Pods
rm -rf ios/Runner/GoogleService-Info.plist
rm -rf ios/firebase_app_id_file.json
rm -rf ios/build
rm -rf ios/Podfile.lock
rm -rf pubspec.lock
rm -rf lib/firebase_options.dart
```

## Clean Temp Cached Files

To clean cache from the code:

```shell
rm -rf .pub-cache/
rm -rf build/
rm -rf .dart_tool/
rm -rf .idea/
rm -rf .vscode/
rm -rf android/.gradle/
rm -rf ios/.symlinks/
rm -rf ios/Pods/
rm -rf ios/build/
rm -rf ios/Podfile.lock
rm -rf ios/Pods/
rm -rf pubspec.lock
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies
rm -rf .flutter-plugins
```
