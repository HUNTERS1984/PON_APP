package com.hunters1984.pon.utils;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by LENOVO on 9/28/2016.
 */

public class SharedPreferenceUtils {

    public static void saveString(Context context, String prefName, String val)
    {
        SharedPreferences sharedPreferences = context.getSharedPreferences(Constants.PREF_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(prefName, val);
        editor.commit();
    }

    public static String getString(Context context, String prefName)
    {
        SharedPreferences sharedPreferences = context.getSharedPreferences(Constants.PREF_NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getString(prefName, "");
    }
}
