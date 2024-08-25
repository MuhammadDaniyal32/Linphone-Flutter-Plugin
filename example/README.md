# Linphone Flutter Plugin Example

This repository provides an example of how to use the [Linphone Flutter Plugin](https://github.com/MuhammadDaniyal32/Linphone-Flutter-Plugin.git) in a Flutter application. The plugin enables integration of Linphone SDK’s native Android calling functionalities with Flutter, supporting VOIP calls over the UDP protocol.

## Getting Started

This example demonstrates how to set up and use the Linphone Flutter Plugin in a Flutter app.

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- An Android device or emulator to run the example.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/MuhammadDaniyal32/Linphone-Flutter-Plugin.git
    ```

2. Navigate to the `example` directory:

    ```bash
    cd Linphone-Flutter-Plugin/example
    ```

3. Update the `pubspec.yaml` file to include the plugin dependency:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      linphone_flutter_plugin:
        git:
          url: https://github.com/MuhammadDaniyal32/Linphone-Flutter-Plugin.git
    ```

4. Get the dependencies:

    ```bash
    flutter pub get
    ```

### Configuration

1. **Initialize the Plugin**: Update `lib/main.dart` to initialize the Linphone plugin and request necessary permissions:

    ```dart
    import 'package:flutter/material.dart';
    import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';

    void main() {
      runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Linphone Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
        );
      }
    }

    class MyHomePage extends StatefulWidget {
      @override
      _MyHomePageState createState() => _MyHomePageState();
    }

    class _MyHomePageState extends State<MyHomePage> {
      final LinphoneFlutterPlugin _linphonePlugin = LinphoneFlutterPlugin();
      final TextEditingController _usernameController = TextEditingController();
      final TextEditingController _passwordController = TextEditingController();
      final TextEditingController _domainController = TextEditingController();
      final TextEditingController _numberController = TextEditingController();

      @override
      void initState() {
        super.initState();
        _initializeLinphone();
      }

      Future<void> _initializeLinphone() async {
        await _linphonePlugin.requestPermissions();
      }

      Future<void> _login() async {
        await _linphonePlugin.login(
          userName: _usernameController.text,
          domain: _domainController.text,
          password: _passwordController.text,
        );
      }

      Future<void> _makeCall() async {
        await _linphonePlugin.call(number: _numberController.text);
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Linphone Example'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: _domainController,
                  decoration: InputDecoration(labelText: 'Domain'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _numberController,
                  decoration: InputDecoration(labelText: 'Number'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _makeCall,
                  child: Text('Call'),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

### Running the Example

1. Ensure an Android device or emulator is running.
2. Execute the following command to start the app:

    ```bash
    flutter run
    ```

### Features Demonstrated

- **Login**: Authenticate with SIP credentials.
- **Call**: Initiate a VOIP call to a specified number.

### Contributing

Feel free to open issues and submit pull requests if you encounter any problems or have improvements to suggest.

### License

This example is provided under the MIT License. See the [LICENSE](https://github.com/MuhammadDaniyal32/Linphone-Flutter-Plugin/blob/main/LICENSE) file for details.

## Acknowledgements

- [Linphone SDK](https://www.linphone.org/) for the VOIP functionality.
- The Flutter community for their support and contributions.
