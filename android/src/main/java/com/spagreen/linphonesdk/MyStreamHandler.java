package com.spagreen.linphonesdk;

import static android.os.BatteryManager.BATTERY_STATUS_CHARGING;
import static android.os.BatteryManager.BATTERY_STATUS_DISCHARGING;
import static android.os.BatteryManager.BATTERY_STATUS_FULL;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;

import io.flutter.plugin.common.EventChannel;

public class MyStreamHandler implements EventChannel.StreamHandler {
    private final String TAG = MyStreamHandler.class.getSimpleName();
    private BroadcastReceiver receiver = null;
    private Context context;

    public MyStreamHandler(Context applicationContext) {
        this.context = applicationContext;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        if (events == null) return;
        receiver = initReceiver(events);
        context.registerReceiver(receiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
    }

    @Override
    public void onCancel(Object arguments) {
        context.unregisterReceiver(receiver);
        receiver = null;
    }

    private BroadcastReceiver initReceiver(EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
                switch (status){
                    case BATTERY_STATUS_CHARGING:
                        events.success("Battery is charging");
                        break;
                    case BATTERY_STATUS_FULL:
                        events.success("Battery is full");
                        break;
                    case BATTERY_STATUS_DISCHARGING:
                        events.success("Battery discharged");
                        break;
                    default:
                        events.success("UNKNOWN");
                        break;
                }
            }
        };
    }
}
