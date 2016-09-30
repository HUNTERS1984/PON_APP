package com.hunters1984.pon.utils;

import android.content.Context;
import android.util.DisplayMetrics;

import com.hunters1984.pon.api.APIConstants;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class CommonUtils {

    public static boolean convertBoolean(int val)
    {
        return (val == APIConstants.TRUE?true:false);
    }

    public static int convertInt(boolean val) {
        return (val?APIConstants.TRUE:APIConstants.FALSE);
    }

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
}
