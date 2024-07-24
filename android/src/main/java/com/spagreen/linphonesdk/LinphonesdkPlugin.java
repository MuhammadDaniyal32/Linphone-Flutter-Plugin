package com.spagreen.linphonesdk;

import android.app.Activity;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

/**
 * LinphonesdkPlugin
 */
public class LinphonesdkPlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel channel;
    private EventChannelHelper loginEventListener;
    private EventChannelHelper callEventListener;
    private Activity activity;
    //event channel
    private EventChannel eventChannel;
    private BinaryMessenger binaryMessenger;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.getBinaryMessenger();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        this.activity = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = (FlutterActivity) binding.getActivity();
        channel = new MethodChannel(binaryMessenger, "linphonesdk");
        loginEventListener = new EventChannelHelper(binaryMessenger, "linphonesdk/login_listener");
        callEventListener = new EventChannelHelper(binaryMessenger, "linphonesdk/call_event_listener");
        MethodCallHandler methodCallHandler = new MethodChannelHandler(activity, loginEventListener, callEventListener);
        channel.setMethodCallHandler(methodCallHandler);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
