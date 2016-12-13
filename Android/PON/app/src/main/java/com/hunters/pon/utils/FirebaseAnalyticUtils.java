package com.hunters.pon.utils;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import com.google.firebase.analytics.FirebaseAnalytics;

/**
 * Created by hle59 on 12/12/2016.
 */

public class FirebaseAnalyticUtils {

    private FirebaseAnalytics mFirebaseAnalytics;
    private static FirebaseAnalyticUtils mFirebaseAnalyticsUtils;

    public FirebaseAnalyticUtils(Context context)
    {
        if(mFirebaseAnalytics == null){
            mFirebaseAnalytics = FirebaseAnalytics.getInstance(context);
        }
    }

    public static FirebaseAnalyticUtils getInstance(Context context)
    {
        if(mFirebaseAnalyticsUtils == null){
            mFirebaseAnalyticsUtils = new FirebaseAnalyticUtils(context);
        }

        return mFirebaseAnalyticsUtils;
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
