package com.hunters.pon.utils;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import com.google.firebase.analytics.FirebaseAnalytics;

/**
 * Created by hle59 on 12/12/2016.
 */

public class FirebaseAnalyticUtils {

    private static FirebaseAnalytics mFirebaseAnalytics;

    public static FirebaseAnalytics getInstance(Context context)
    {
        if(mFirebaseAnalytics == null){
            mFirebaseAnalytics = FirebaseAnalytics.getInstance(context);
        }

        return mFirebaseAnalytics;
    }

    public void logEventShareCoupon(String name, String type)
    {
        Bundle params = new Bundle();
        params.putString("coupon_name", name);
        params.putString("share_type", type);
        mFirebaseAnalytics.logEvent("share_coupon", params);
    }

    public void logScreenAccess(Activity activity, String screenName)
    {
        mFirebaseAnalytics.setCurrentScreen(activity, screenName, null);
    }

}
