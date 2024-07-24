import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:linphone_flutter_plugin/CallLog.dart';
import 'package:linphone_flutter_plugin/call_state.dart';
import 'package:linphone_flutter_plugin/login_state.dart';

class LinphoneFlutterPlugin {
  static const MethodChannel _channel = MethodChannel("linphonesdk");
  static const EventChannel _loginEventListener =
      EventChannel("linphonesdk/login_listener");
  static const EventChannel _callEventListener =
      EventChannel("linphonesdk/call_event_listener");

  Future<void> requestPermissions() async {
    try {
      return await _channel.invokeMethod('request_permissions');
    } catch (e) {
      throw FormatException("Error on request permission. $e");
    }
  }

  Future<void> login(
      {required String userName,
      required String domain,
      required String password}) async {
    var data = {"userName": userName, "domain": domain, "password": password};
    return await _channel.invokeMethod("login", data);
  }

  Future<void> toggleSpeaker() async {
    return await _channel.invokeMethod("toggle_speaker");
  }

  Future<bool> toggleMute() async {
    return await _channel.invokeMethod("mute");
  }

  Future<void> call({required String number}) async {
    var data = {"number": number};
    return await _channel.invokeMethod("call", data);
  }

  Future<void> hangUp() async {
    return await _channel.invokeMethod("hangUp");
  }

  Future<void> removeLoginListener() async {
    return _channel.invokeMethod("remove_listener");
  }

  Future<void> removeCallListener() async {
    return _channel.invokeMethod("remove_call_listener");
  }

  Future<bool> callTransfer({required String destination})async{
    var data = {"destination": destination};
    return await _channel.invokeMethod("transfer", data);
  }

  Future<CallLogs> callLogs()async{
   var list =  await _channel.invokeMethod("call_logs");
    return  CallLogs.fromJson(jsonDecode(list));
  }

  Future<void> answercall()async{
    return await _channel.invokeMethod("answerCall");
  }

  Future<void> rejectCall()async{
    return await _channel.invokeMethod("rejectCall");
  }

  Stream<LoginState> addLoginListener() {
    return _loginEventListener.receiveBroadcastStream().map((event) {
      LoginState loginState = LoginState.none;
      if (event == "Ok") {
        loginState = LoginState.ok;
      } else if (event == "Progress") {
        loginState = LoginState.progress;
      } else if (event == "None") {
        loginState = LoginState.none;
      } else if (event == "Cleared") {
        loginState = LoginState.cleared;
      } else if (event == "Failed") {
        loginState = LoginState.failed;
      }
      return loginState;
    });
  }


  Stream<CallState> addCallStateListener() {
    return _callEventListener.receiveBroadcastStream().map((event) {
      print("Event: $event");
      CallState callState = CallState.idle;
      if (event == "IncomingReceived") {
        callState = CallState.IncomingReceived;
      } else if (event == "OutgoingInit") {
        callState = CallState.outgoingInit;
      } else if (event == "OutgoingProgress") {
        callState = CallState.outgoingProgress;
      } else if (event == "OutgoingRinging") {
        callState = CallState.outgoingRinging;
      } else if (event == "Connected") {
        callState = CallState.connected;
      } else if (event == "StreamsRunning") {
        callState = CallState.streamsRunning;
      } else if (event == "Paused") {
        callState = CallState.paused;
      } else if (event == "PausedByRemote") {
        callState = CallState.pausedByRemote;
      } else if (event == "Updating") {
        callState = CallState.updating;
      } else if (event == "UpdatedByRemote") {
        callState = CallState.updatedByRemote;
      } else if (event == "Released") {
        callState = CallState.released;
      } else if (event == "EarlyUpdatedByRemote") {
        callState = CallState.earlyUpdatedByRemote;
      } else if (event == "Error") {
        callState = CallState.error;
      }
      return callState;
    });
  }
}
