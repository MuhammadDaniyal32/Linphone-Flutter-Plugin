import 'package:flutter/material.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
import 'package:linphone_flutter_plugin/CallLog.dart';
import 'package:linphone_flutter_plugin/call_state.dart';
import 'dart:async';
import 'package:linphone_flutter_plugin/login_state.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Instance of the Linphone Flutter Plugin
  final _linphoneSdkPlugin = LinphoneFlutterPlugin();

  // TextEditingControllers for handling user input in text fields
  late TextEditingController _userController;
  late TextEditingController _passController;
  late TextEditingController _domainController;
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingControllers
    _userController = TextEditingController();
    _passController = TextEditingController();
    _domainController = TextEditingController();

    // Request necessary permissions for using Linphone features
    requestPermissions();
  }



  // Request permissions needed by the Linphone SDK
  Future<void> requestPermissions() async {
    try {
      await _linphoneSdkPlugin.requestPermissions();
    } catch (e) {
      print("Error on request permission. ${e.toString()}");
    }
  }

  // Login method to authenticate the user using Linphone
  Future<void> login({
    required String username,
    required String pass,
    required String domain,
  }) async {
    try {
      await _linphoneSdkPlugin.login(
          userName: username, domain: domain, password: pass);
    } catch (e) {
      // Show error message if login fails
      print("Error on login. ${e.toString()}");
    }
  }

  // Method to initiate a call using the Linphone SDK
  Future<void> call() async {
    if (_textEditingController.text.isNotEmpty) {
      String number = _textEditingController.text;
      try {
        await _linphoneSdkPlugin.call(number: number);
      } catch (e) {
        // Show error message if the call fails
        print("Error on call. ${e.toString()}");
      }
    }
  }

  // Method to transfer an ongoing call to another number
  Future<void> forward() async {
    try {
      await _linphoneSdkPlugin.callTransfer(destination: "1000");
    } catch (e) {
      // Show error message if call transfer fails
      print("Error on call transfer. ${e.toString()}");
    }
  }

  // Method to hang up an ongoing call
  Future<void> hangUp() async {
    try {
      await _linphoneSdkPlugin.hangUp();
    } catch (e) {
      // Show error message if hang up fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hang up failed: ${e.toString()}")),
      );
    }
  }

  // Method to toggle the speaker on/off
  Future<void> toggleSpeaker() async {
    try {
      await _linphoneSdkPlugin.toggleSpeaker();
    } catch (e) {
      // Show error message if toggling the speaker fails
      print("Error on toggle speaker. ${e.toString()}");
    }
  }

  // Method to toggle mute on/off
  Future<void> toggleMute() async {
    try {
      bool isMuted = await _linphoneSdkPlugin.toggleMute();
      // Show feedback to the user about the mute status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isMuted ? "Muted" : "Unmuted")),
      );
    } catch (e) {
      // Show error message if toggling mute fails
      print("Error on toggle mute. ${e.toString()}");
    }
  }

  // Method to answer an incoming call
  Future<void> answer() async {
    try {
      await _linphoneSdkPlugin.answercall();
    } catch (e) {
      // Show error message if answering the call fails
      print("Error on answer call. ${e.toString()}");
    }
  }

  // Method to reject an incoming call
  Future<void> reject() async {
    try {
      await _linphoneSdkPlugin.rejectCall();
    } catch (e) {
      // Show error message if rejecting the call fails
      print("Error on reject call. ${e.toString()}");
    }
  }

  // Method to retrieve and print the call logs
  Future<void> callLogs() async {
    try {
      CallLogs callLogs = await _linphoneSdkPlugin.callLogs();
      print("---------call logs length: ${callLogs.callHistory.length}");
    } catch (e) {
      // Show error message if fetching call logs fails
      print("Error on call logs. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Linphone Flutter Plugin Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Username input field
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Input username",
                labelText: "Username",
              ),
            ),
            // Password input field
            TextFormField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: "Input password",
                labelText: "Password",
              ),
            ),
            // Domain input field
            TextFormField(
              controller: _domainController,
              decoration: const InputDecoration(
                icon: Icon(Icons.domain),
                hintText: "Input domain",
                labelText: "Domain",
              ),
            ),
            const SizedBox(height: 20),
            // Login button
            ElevatedButton(
              onPressed: () {
                login(
                  username: _userController.text,
                  pass: _passController.text,
                  domain: _domainController.text,
                );
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            // Display login status
            StreamBuilder<LoginState>(
              stream: _linphoneSdkPlugin.addLoginListener(),
              builder: (context, snapshot) {
                LoginState status = snapshot.data ?? LoginState.none;
                return Text("Login status: ${status.name}");
              },
            ),
            const SizedBox(height: 20),
            // Display call status
            StreamBuilder<CallState>(
              stream: _linphoneSdkPlugin.addCallStateListener(),
              builder: (context, snapshot) {
                CallState? status = snapshot.data;
                if (status == CallState.IncomingReceived) {
                  return AlertDialog(
                    title: const Text('Incoming Call'),
                    content: const Text('You have an incoming call.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await reject();
                          if (mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Reject'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await answer();
                          if (mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Answer'),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Text("Call status: ${status?.name}"),
                    if (status == CallState.outgoingInit ||
                        status == CallState.outgoingProgress)
                      ElevatedButton(
                          onPressed: hangUp, child: const Text("Hang Up")),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Phone number input field
            TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "Input number",
                labelText: "Number",
              ),
            ),
            const SizedBox(height: 20),
            // Call button
            ElevatedButton(onPressed: call, child: const Text("Call")),
            const SizedBox(height: 20),
            // Answer button
            ElevatedButton(
              onPressed: () {
                answer();
              },
              child: const Text("Answer"),
            ),
            const SizedBox(height: 20),
            // Reject button
            ElevatedButton(
              onPressed: () {
                reject();
              },
              child: const Text("Reject"),
            ),
            // Hang up button
            ElevatedButton(
              onPressed: () {
                hangUp();
              },
              child: const Text("Hang Up"),
            ),
            const SizedBox(height: 20),
            // Toggle speaker button
            ElevatedButton(
              onPressed: () {
                toggleSpeaker();
              },
              child: const Text("Speaker"),
            ),
            const SizedBox(height: 20),
            // Toggle mute button
            ElevatedButton(
              onPressed: () {
                toggleMute();
              },
              child: const Text("Mute"),
            ),
            const SizedBox(height: 20),
            // Forward call button
            ElevatedButton(
              onPressed: () {
                forward();
              },
              child: const Text("Forward"),
            ),
            const SizedBox(height: 20),
            // Call log button
            ElevatedButton(
              onPressed: () {
                callLogs();
              },
              child: const Text("Call Log"),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Remove listeners and dispose of controllers to prevent memory leaks
    _linphoneSdkPlugin.removeLoginListener();
    _linphoneSdkPlugin.removeCallListener();
    _userController.dispose();
    _passController.dispose();
    _domainController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}
