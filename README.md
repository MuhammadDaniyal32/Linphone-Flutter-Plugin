# Linphone Flutter Plugin

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Linphone](https://img.shields.io/badge/Linphone-%230089CE.svg?style=for-the-badge&logo=Linphone&logoColor=white) [![linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mdaniyalnoo)


**Linphone Flutter Plugin** is a Flutter plugin that allows you to integrate Linphone SDK's native Android calling functionalities into your Flutter application. This plugin is designed for VOIP calling using the UDP protocol, making it ideal for real-time voice communication in your app.

## Features

- **Native Android Integration**: Utilize the power of Linphone SDK for seamless VOIP calling.
- **UDP Protocol Support**: Ensures fast and efficient communication with minimal latency.
- **Call Handling**: Initiate, receive, and manage VOIP calls directly from your Flutter app.
- **Call Logs**: Retrieve call history for tracking and analysis.
- **Mute, Speaker, and Call Transfer**: Control the call state with advanced features.

## Installation

To use this plugin, add `linphone flutter plugin` as a dependency in your `pubspec.yaml` file:

- Run this command:
```yaml
 $ flutter pub add Linphone-Flutter-Plugin
```

## Usage
- Import the plugin
```dart
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
```
## Android Permissions
- Add permission in AndroidManifest.xml

```xml
<manifest...>
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.CALL_PHONE" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.SYSTEM_CAMERA" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_CAMERA" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_PHONE_CALL" />
    <uses-permission android:name="android.permission.MANAGE_OWN_CALLS" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
</manifest>
```


### Initialize the Plugin
- Before you can make or receive calls, you need to initialize the Linphone plugin and request the necessary permissions.
```dart
final _linphoneSdkPlugin = LinphoneFlutterPlugin();

Future<void> initLinphone() async {
  await _linphoneSdkPlugin.requestPermissions();
}
```
### Login
- To start using Linphone, you need to log in with your SIP credentials.

```dart
Future<void> login({
  required String username,
  required String password,
  required String domain,
}) async {
  await _linphoneSdkPlugin.login(userName: username, domain: domain, password: password);
}
```

### Make a Call
- Initiate a call by specifying the recipient’s number.
```dart
Future<void> call(String number) async {
  await _linphoneSdkPlugin.call(number: number);
}
```
### Receive a Call
- You can listen for incoming calls and handle them accordingly.
```dart
_linphoneSdkPlugin.addCallStateListener().listen((CallState state) {
  if (state == CallState.IncomingReceived) {
    // Handle incoming call
  }
});
```

### Hang Up
- End an ongoing call.
```dart
Future<void> hangUp() async {
  await _linphoneSdkPlugin.hangUp();
}
```

## Example

Check out the [example](https://github.com/MuhammadDaniyal32/Linphone-Flutter-Plugin/tree/main/example) directory for a complete example of how to use this plugin.

## Contributing

Contributions are welcome! Please submit issues and pull requests to help improve the plugin.

## License
This project is licensed under the MIT License. See the LICENSE file for details.