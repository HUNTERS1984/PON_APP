package com.hunters.pon.application;

import android.app.Application;

import com.hunters.pon.pushnotification.PonNotificationOpenedHandler;
import com.onesignal.OneSignal;

/**
 * Created by LENOVO on 10/9/2016.
 */

public class PonApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        OneSignal.startInit(this)
                .setNotificationOpenedHandler(new PonNotificationOpenedHandler(getApplicationContext()))
                .init();

        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail);
    }
}
