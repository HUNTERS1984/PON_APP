package com.hunters.pon.utils;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.util.DisplayMetrics;

import com.hunters.pon.models.UserModel;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class CommonUtils {

//    public static boolean convertBoolean(int val)
//    {
//        return (val == APIConstants.TRUE?true:false);
//    }
//
//    public static int convertInt(boolean val) {
//        return (val?APIConstants.TRUE:APIConstants.FALSE);
//    }

    public static String convertDateFormat(String datetime)
    {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss+0000");
        Date testDate = null;
        try {
            testDate = sdf.parse(datetime);
        }catch(Exception ex){
            ex.printStackTrace();
        }
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
        return formatter.format(testDate);
    }

    public static void saveToken(Context context, String token)
    {
        SharedPreferenceUtils.saveString(context, Constants.PREF_TOKEN, token);
    }

    public static String getToken(Context context)
    {
        return SharedPreferenceUtils.getString(context, Constants.PREF_TOKEN);
    }

    public static boolean isLogin(Context context) {
        String token = getToken(context);
        if(token.equalsIgnoreCase("")){
            return false;
        }

        return true;

    }

    public static int dpToPx(Context context, int dp) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        int px = Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT));
        return px;
    }

    public static boolean isPackageInstalled(Context context, String packagename) {
        try {
            context.getPackageManager().getPackageInfo(packagename, PackageManager.GET_ACTIVITIES);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
    public static String getFileCache(String fileName)
    {
//        File dir = new File(Environment.getDataDirectory() + "/PON/");
//        if (!dir.exists()) {
//            dir.mkdir();
//        }
        File dir = Environment.getDataDirectory();

        if (Environment.getExternalStorageState() != null) {
            dir = Environment.getExternalStorageDirectory();
        }
        return dir.getAbsolutePath() + "/" + fileName;
    }

    public static UserModel getProfile(Context context)
    {
        UserModel user = new UserModel();
        user.setmAddress(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_ADDRESS));
        user.setmAvatarUrl(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_AVATAR));
        user.setmEmail(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_EMAIL));
        user.setmGender(SharedPreferenceUtils.getInt(context, Constants.PREF_PROFILE_GENDER));
        user.setmName(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_FULLNAME));
        user.setmUsername(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_USERNAME));
        user.setmId(SharedPreferenceUtils.getInt(context, Constants.PREF_PROFILE_ID));
        user.setmFollowShopNumber(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_FOLLOW_NUMBER));
        user.setmCouponUsedNumber(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_HISTORY_NUMBER));
        user.setmNewsNumber(SharedPreferenceUtils.getString(context, Constants.PREF_PROFILE_NEWS_NUMBER));
        return user;
    }

    public static void saveProfile(Context context, UserModel user)
    {
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_ADDRESS, user.getmAddress());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_AVATAR, user.getmAvatarUrl());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_EMAIL, user.getmEmail());
        SharedPreferenceUtils.saveInt(context, Constants.PREF_PROFILE_GENDER, user.getmGender());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_FULLNAME, user.getmName());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_USERNAME, user.getmUsername());
        SharedPreferenceUtils.saveInt(context, Constants.PREF_PROFILE_ID, user.getmId());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_FOLLOW_NUMBER, user.getmFollowShopNumber());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_HISTORY_NUMBER, user.getmCouponUsedNumber());
        SharedPreferenceUtils.saveString(context, Constants.PREF_PROFILE_NEWS_NUMBER, user.getmNewsNumber());
    }

    public static boolean isEmailValid(CharSequence email) {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    public static void setLoginType(Context context, int type)
    {
        SharedPreferenceUtils.saveInt(context, Constants.PREF_LOGIN_TYPE, type);
    }

    public static int getLogintype(Context context)
    {
        return SharedPreferenceUtils.getInt(context, Constants.PREF_LOGIN_TYPE);
    }
//    public static long getFileSize(String path)
//    {
//        File file = new File(path);
//
//        long fileSizeInMB = (file.length() / 1024) / 1024;
//
//        return fileSizeInMB;
//    }
}
