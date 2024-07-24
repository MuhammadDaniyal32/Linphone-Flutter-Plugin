import 'package:flutter/material.dart';
import 'package:linphone_flutter_plugin/linphoneflutterplugin.dart';
import 'package:linphone_flutter_plugin/CallLog.dart';
import 'package:linphone_flutter_plugin/call_state.dart';
import 'dart:async';
import 'package:linphone_flutter_plugin/login_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _linphoneSdkPlugin = LinphoneFlutterPlugin();
  final _textEditingController = TextEditingController();
  @override
  void dispose() {
    _linphoneSdkPlugin.removeLoginListener();
    _linphoneSdkPlugin.removeCallListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    try {
      await _linphoneSdkPlugin.requestPermissions();
    } catch (e) {
      print("Error on request permission. ${e.toString()}");
    }
  }

  Future<void> login(
      {required String username,
        required String pass,
        required String domain}) async {
    await _linphoneSdkPlugin.login(
        userName: username, domain: domain, password: pass);
  }

  Future<void> call() async {
    if (_textEditingController.text.isNotEmpty) {
      String number = _textEditingController.text;
      await _linphoneSdkPlugin.call(number: number);
    }
  }

  Future<void> forward() async {
    await _linphoneSdkPlugin.callTransfer(destination: "1000");
  }

  Future<void> hangUp() async {
    await _linphoneSdkPlugin.hangUp();
  }

  Future<void> toggleSpeaker() async {
    await _linphoneSdkPlugin.toggleSpeaker();
  }

  Future<bool> toggleMute() async {
    return await _linphoneSdkPlugin.toggleMute();
  }

  Future<void> answer() async {
    await _linphoneSdkPlugin.answercall();
  }

  Future<void> reject() async {
    await _linphoneSdkPlugin.rejectCall();
  }


  Future<void> callLogs() async {
    CallLogs callLogs = await _linphoneSdkPlugin.callLogs();
    print("---------call logs length: ${callLogs.callHistory.length}");
  }

  void showIncomingCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incoming Call'),
          content: Text('You have an incoming call.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reject();
              },
              child: Text('Reject'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                answer();
              },
              child: Text('Answer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
    final TextEditingController _domainController = TextEditingController();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Linphone SDK Example'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Input username",
                labelText: "Username",
              ),
            ),
            TextFormField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: "Input password",
                labelText: "Password",
              ),
            ),
            TextFormField(
              controller: _domainController,
              decoration: const InputDecoration(
                icon: Icon(Icons.domain),
                hintText: "Input domain",
                labelText: "Domain",
              ),
            ),
            const SizedBox(height: 20),
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
            StreamBuilder<LoginState>(
              stream: _linphoneSdkPlugin.addLoginListener(),
              builder: (context, snapshot) {
                LoginState status = snapshot.data ?? LoginState.none;
                return Text("Login status: ${status.name}");
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<CallState>(
              stream: _linphoneSdkPlugin.addCallStateListener(),
              builder: (context, snapshot) {
                CallState? status = snapshot.data;
                return Text("Call status: ${status?.name}");
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<CallState>(
              stream: _linphoneSdkPlugin.addCallStateListener(),
              builder: (context, snapshot) {
                CallState? status = snapshot.data;
                if (status == CallState.IncomingReceived) {
                 return Dialog(
                    child: Column(
                      children: [
                        Text("Incoming call status: $status"),
                        ElevatedButton(
                          onPressed: () {
                            answer();
                          },
                          child: const Text("Answer"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            reject();
                          },
                          child: const Text("Reject"),
                        ),
                      ],
                    )
                  );
                }
                return Text("Incoming call status: $status");
              },
            ),
            const SizedBox(height: 20),
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
            ElevatedButton(onPressed: call, child: const Text("Call")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                answer();
              },
              child: const Text("Answer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                reject();
              },
              child: const Text("Reject"),
            ),
            ElevatedButton(
              onPressed: () {
                hangUp();
              },
              child: const Text("HangUp"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                toggleSpeaker();
              },
              child: const Text("Speaker"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                toggleMute();
              },
              child: const Text("Mute"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                forward();
              },
              child: const Text("Forward"),
            ),
            const SizedBox(height: 20),
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
}
