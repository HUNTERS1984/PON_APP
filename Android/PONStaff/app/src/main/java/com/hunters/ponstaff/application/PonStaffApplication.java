package com.hunters.ponstaff.application;

import android.app.Application;

import com.onesignal.OneSignal;

/**
 * Created by hle59 on 11/10/2016.
 */

public class PonStaffApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        OneSignal.startInit(this).init();

        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail);
    }
}