# Project Setup

## Installing the Flutter environment

The first step to run this project is to have Flutter installed and properly configured on your machine.

You can do that by following the instruction found on the [official flutter docs](https://flutter.dev/docs/get-started/install). These instructions are very detailed and should guide you through the entire installation process. Make sure to download the latest **stable** version of Flutter.  

Once you have Flutter installed, run `flutter doctor` in your terminal to make sure everything is running as expected. If this command executes successfully, you can proceed with the rest of the setup process.

If you're planning to build the app for android devices, make sure you have the latest android sdk (version 30) installed on your machine too. You can do that by installing Android Studio and going through the ‘Android Studio Setup Wizard’.

To build the app for iOS devices, you need a machine running macOs and to have xcode installed. This is covered in the flutter installation tutorial [for the macOS devices](https://flutter.dev/docs/get-started/install/macos#ios-setup).

## Running the project for the first time

1. Download the project to your machine and extract it to the desired location.
2. Open a terminal inside the root directory of the project.
3. Run `flutter pub get`. This should get all the needed dependencies for the project.
4. From here you have two options:
   - Run the project directly from the terminal by executing `flutter run` in the project's root directory.
   - Open the project in Android Studio or VSCode and press the run button.

**Important Note:** Running the project like that installs the `debug` version of the app on the device. It's usually slower, bigger in size and not meant for testing the performance or animations in the app. To run the `release` version of the app, you need to open the terminal in the root project folder and execute `flutter run --release`.