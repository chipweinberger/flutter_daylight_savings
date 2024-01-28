package com.lib.flutter_daylight_savings;

import java.util.Calendar;
import java.util.TimeZone;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterDaylightSavingsPlugin implements
    FlutterPlugin,
    MethodChannel.MethodCallHandler
{
    private static final String TAG = "[FDS-Android]";
    private static final String CHANNEL_NAME = "flutter_daylight_savings/methods";
    private MethodChannel mMethodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BinaryMessenger messenger = binding.getBinaryMessenger();
        mMethodChannel = new MethodChannel(messenger, CHANNEL_NAME);
        mMethodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mMethodChannel.setMethodCallHandler(null);
        cleanup();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        switch (call.method) {
            case "getNextTransitions":
                int count = call.argument("count");

                TimeZone timeZone = TimeZone.getDefault(); 
                Calendar calendar = Calendar.getInstance(timeZone);

                List<Map<String, Object>> transitions = new ArrayList<>();
                int got = 0;
                while (got < count) {
                    // Move to the next day
                    calendar.add(Calendar.DATE, 1);

                    // Check if DST changes on this day
                    if (timeZone.inDaylightTime(calendar.getTime())) {
                        // Move to the next day where DST doesn't apply
                        while (timeZone.inDaylightTime(calendar.getTime())) {
                            calendar.add(Calendar.DATE, 1);
                        }

                        // DST Transition found, get Unix timestamp and local offset
                        long unixTimestamp = calendar.getTimeInMillis() / 1000;
                        int localOffset = timeZone.getOffset(calendar.getTimeInMillis()) / 1000 / 60;

                        // Create a map to store transition details
                        Map<String, Object> transitionDetails = new HashMap<>();
                        transitionDetails.put("timestamp", unixTimestamp);
                        transitionDetails.put("offset", localOffset);

                        // Add to the transitions list
                        transitions.add(transitionDetails);

                        // Increment the count
                        got++;
                    }
                }

                result.success(transitions);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
