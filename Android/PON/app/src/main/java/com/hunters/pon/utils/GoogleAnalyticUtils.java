package com.hunters.pon.utils;

import android.content.Context;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.hunters.pon.application.PonApplication;

/**
 * Created by hle59 on 12/12/2016.
 */

public class GoogleAnalyticUtils {

    private static GoogleAnalyticUtils mFirebaseAnalyticsUtils;


    public static GoogleAnalyticUtils getInstance(Context context)
    {
        if(mFirebaseAnalyticsUtils == null){
            mFirebaseAnalyticsUtils = new GoogleAnalyticUtils();
        }

        return mFirebaseAnalyticsUtils;
    }

    public void logEventFollowShop(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
            .setCategory("Action")
            .setAction("Follow Shop")
            .build());

    }

    public void logEventUseCoupon(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Use Coupon")
                .build());

    }

    public void logEventLikeCoupon(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Like Coupon")
                .build());

    }

    public void logEventShare(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory("Action")
                .setAction("Share")
                .build());

    }

    public void logScreenAccess(PonApplication application, String screenName)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.setScreenName(screenName);
        tracker.send(new HitBuilders.ScreenViewBuilder().build());
    }

}
