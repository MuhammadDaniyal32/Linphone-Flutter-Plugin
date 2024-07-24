package com.spagreen.linphonesdk;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

public class EventChannelHelper {
    private final String TAG = EventChannelHelper.class.getSimpleName();
    public Handler handler;
    private EventChannel.EventSink eventSink;

    public EventChannelHelper(BinaryMessenger messenger, String id) {
        handler = new Handler(Looper.getMainLooper());
        EventChannel eventChannel = new EventChannel(messenger, id);
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                synchronized (this) {
                    EventChannelHelper.this.eventSink = events;
                }
            }

            @Override
            public void onCancel(Object arguments) {
                synchronized ((this)) {
                    eventSink = null;
                }
            }
        });
    }

    public synchronized void error(String errorCode, String errorMessage, Object errorDetails) {
        if (eventSink == null) return;
        handler.post(() -> eventSink.error(errorCode, errorMessage, errorDetails));
    }

    public synchronized void success(String event) {
        if (eventSink == null) return;
        handler.post(() -> eventSink.success(event));
    }
}
