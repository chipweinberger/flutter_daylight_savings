package com.lib.flutter_daylight_savings;

import java.util.Calendar;
import java.util.TimeZone;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;

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
    }

@Override
public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
        case "getNextTransitions":
            int count = call.argument("count");

            long thirtyDays = 30L * 24 * 60 * 60 * 1000;
            long oneDay = 24L * 60 * 60 * 1000;
            long oneMinute = 60 * 1000;

            TimeZone timeZone = TimeZone.getDefault(); 
            long currentTime = System.currentTimeMillis();

            long prevTime = currentTime;
            long prevOffset = timeZone.getOffset(prevTime);

            List<Map<String, Object>> transitions = new ArrayList<>();

            int monthsWithoutTransition = 0;

            while (transitions.size() < count) {

                // prevent infinite loop
                if (monthsWithoutTransition >= 36) {
                    break;
                }
                
                // go to next month
                currentTime += thirtyDays;

                // found transition?
                if (prevOffset != timeZone.getOffset(currentTime)) {

                    // Reset counter as transition is found
                    monthsWithoutTransition = 0; 

                    // go back to previous month
                    long dayTime = currentTime - thirtyDays;

                    // check day by day
                    for (int day = 0; day < 30; day++) {

                        // go to next day
                        dayTime += oneDay;

                        // found transition?
                        if (prevOffset != timeZone.getOffset(dayTime)) {

                            // go back to previous day
                            long minuteTime = dayTime - oneDay;

                            // check minute by minute
                            // 1440 minutes in a day
                            for (int minute = 0; minute < 1440; minute++) {

                                // go to next minute
                                minuteTime += oneMinute;

                                // get timezone offset
                                long currentOffset = timeZone.getOffset(minuteTime);

                                // found transition?
                                if (prevOffset != currentOffset) {

                                    // DST Transition found
                                    Map<String, Object> transitionDetails = new HashMap<>();
                                    transitionDetails.put("timestamp", minuteTime / 1000);
                                    transitionDetails.put("offset", currentOffset / 1000 / 60);
                                    transitions.add(transitionDetails);

                                    prevOffset = currentOffset;

                                    break; // Exit minute loop
                                }
                            }
                            break; // Exit day loop
                        }
                    }
                }
                
                monthsWithoutTransition++;

                prevTime = currentTime;
            }

            result.success(transitions);
            break;
        default:
            result.notImplemented();
            break;
   
    }
}



}
