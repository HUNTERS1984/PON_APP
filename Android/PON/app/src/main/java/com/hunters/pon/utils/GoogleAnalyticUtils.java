package com.hunters.pon.utils;

import android.content.Context;

import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.hunters.pon.application.PonApplication;

/**
 * Created by hle59 on 12/12/2016.
 */

public class GoogleAnalyticUtils {

    //Screen Name
    public static final String SPLASH_SCREEN = "Splash Screen";
    public static final String SELECT_LOGIN_TYPE_SCREEN = "Select Login Type Screen";
    public static final String LOGIN_EMAIL_SCREEN = "Login Email Screen";
    public static final String SIGN_UP_SCREEN = "Sign Up Screen";
    public static final String FORGOT_PASS_SCREEN = "Forgot Password Screen";
    public static final String MAIN_TOP_SCREEN = "Main Top Screen";
    public static final String PROFILE_SCREEN = "Profile Screen";
    public static final String MY_FAVOURITE_SCREEN = "My Favourite Screen";
    public static final String SHOP_CATEGORY_SCREEN = "Shop Category Screen";
    public static final String ADD_FOLLOW_SHOPP_SCREEN = "Add Follow Shop Screen";
    public static final String COUPON_CATEGORY_SCREEN = "Coupon Category Screen";
    public static final String COUPON_CATEGORY_DETAIL_SCREEN = "Coupon Category Detail Screen";
    public static final String MAP_SCREEN = "Map Screen";
    public static final String COUPON_DETAIL_SCREEN = "Coupon Detail Screen";
    public static final String SHOP_DETAIL_SCREEN = "Shop Detail Screen";
    public static final String SEARCH_SCREEN = "Search Screen";
    public static final String SHARE_COUPON_SCREEN = "Share Coupon Screen";
    public static final String PROFILE_FOLLOW_SHOP_SCREEN = "Profile Follow Shop Screen";
    public static final String PROFILE_USED_COUPON_SCREEN = "Profile Used Coupon Screen";
    public static final String PROFILE_NEWS_SCREEN = "Profile News Screen";
    public static final String PROFILE_NEWS_DETAIL_SCREEN = "Profile News Detail Screen";
    public static final String PROFILE_EDIT_SCREEN = "Profile Edit Screen";
    public static final String PROFILE_CHANGE_PASSWORD_SCREEN = "Profile Change Password Screen";
    public static final String VIEW_PHOTO_SCREEN = "View Photo Screen";
    public static final String PRIVACY_POLICY_SCREEN = "Privacy Policy Screen";
    public static final String SPECIFIC_TRADE_SCREEN = "Specific Trade Screen";

    //Event Name
    public static final String ACTION_NAME = "Action";
    public static final String EVENT_FOLLOW_SHOP = "Follow Shop";
    public static final String EVENT_USE_COUPON = "Use Coupon";
    public static final String EVENT_LIKE_COUPON = "Like Coupon";
    public static final String EVENT_SHARE_COUPON = "Share Coupon";
    public static final String EVENT_SHARE_SHOP = "Share Shop";


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
            .setCategory(ACTION_NAME)
            .setAction(EVENT_FOLLOW_SHOP)
            .build());

    }

    public void logEventUseCoupon(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(ACTION_NAME)
                .setAction(EVENT_USE_COUPON)
                .build());

    }

    public void logEventLikeCoupon(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(ACTION_NAME)
                .setAction(EVENT_LIKE_COUPON)
                .build());

    }

    public void logEventShareCoupon(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(ACTION_NAME)
                .setAction(EVENT_SHARE_COUPON)
                .build());

    }

    public void logEventShareShop(PonApplication application)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.send(new HitBuilders.EventBuilder()
                .setCategory(ACTION_NAME)
                .setAction(EVENT_SHARE_SHOP)
                .build());

    }

    public void logScreenAccess(PonApplication application, String screenName)
    {
        Tracker tracker = application.getDefaultTracker();
        tracker.setScreenName(screenName);
        tracker.send(new HitBuilders.ScreenViewBuilder().build());
    }

}
