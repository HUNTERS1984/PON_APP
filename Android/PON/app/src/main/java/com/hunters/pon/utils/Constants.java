package com.hunters.pon.utils;

/**
 * Created by LENOVO on 9/28/2016.
 */

public class Constants {

    //SNS
    public static final String INSTAGRAM_CLIENT_ID = "cd9f614f85f44238ace18045a51c44d1";// "b2d65acf4c62464fad96b53884bb0df7";
    public static final String INSTAGRAM_CLIENT_SECRET = "d839149848c04447bd379ce8bff4d890";//"8d6591f0375b4ea38d69eec58d7cfc4a";
    public static final String INSTAGRAM_CALLBACK_URL = "https://mytenant.auth0.com/login/callback";

    public static final String PREF_NAME = "PREF_PON";
    public static final String PREF_TOKEN = "token";
    public static final String PREF_PROFILE_USERNAME = "profile_username";
    public static final String PREF_PROFILE_FULLNAME = "profile_fullname";
    public static final String PREF_PROFILE_EMAIL = "profile_email";
    public static final String PREF_PROFILE_GENDER = "profile_gender";
    public static final String PREF_PROFILE_ADDRESS = "profile_address";
    public static final String PREF_PROFILE_AVATAR = "profile_avatar";
    public static final String PREF_PROFILE_ID = "profile_id";
    public static final String PREF_PROFILE_FOLLOW_NUMBER = "profile_follow_number";
    public static final String PREF_PROFILE_HISTORY_NUMBER = "profile_history_number";
    public static final String PREF_PROFILE_NEWS_NUMBER = "profile_news_number";
    public static final String PREF_LOGIN_TYPE = "login_type";
    public static final int LOGIN_EMAIL = 1;
    public static final int LOGIN_SNS = 2;

    public static final String EXTRA_USER_NAME = "EXTRA_USER_NAME";
    public static final String EXTRA_COUPON_ID = "EXTRA_COUPON_ID";
    public static final String EXTRA_COUPON_TYPE_ID = "EXTRA_COUPON_TYPE_ID";
    public static final String EXTRA_SHOP_ID = "EXTRA_SHOP_ID";
    public static final String EXTRA_TITLE = "EXTRA_TITLE";
    public static final String EXTRA_USER = "EXTRA_USER";
    public static final String EXTRA_DATA = "EXTRA_DATA";
    public static final String EXTRA_ID = "EXTRA_ID";

    public static final String TYPE_POPULARITY_COUPON = "1";
    public static final String TYPE_NEWEST_COUPON = "2";
    public static final String TYPE_NEAREST_COUPON = "3";
    public static final String TYPE_USED_COUPON = "4";

    public static final String HEADER_AUTHORIZATION = "Bearer %s";

    public static final String PACKAGE_INSTAGRAM = "com.instagram.android";
    public static final String PACKAGE_LINE = "jp.naver.line.android";

    public static final String NOTIFICATION_NEW_COUPON = "new_coupon";
    public static final String NOTIFICATION_NEWS = "new_news";
    public static final String NOTIFICATION_COUPON_APPROVED = "coupon_approved";

    public static final int VIEW_TYPE_ITEM = 0;
    public static final int VIEW_TYPE_LOADING = 1;

    public static final String EXTRA_ADD_FAVOURITE = "ADD_FAVOURITE";
    public static final String EXTRA_VIEW_COUPON_DETAIL = "VIEW_COUPON_DETAIL";
    public static final String EXTRA_FOLLOW_SHOP = "FOLLOW_SHOP";
    public static final String EXTRA_USE_COUPON = "USE_COUPON";

    public static final int REQUEST_CODE_COUPON_DETAIL = 1001;
    public static final int REQUEST_CODE_ADD_FAVOURITE = 1002;
    public static final int REQUEST_CODE_FOLLOW_SHOP = 1003;
    public static final int REQUEST_CODE_USE_COUPON = 1004;

}
