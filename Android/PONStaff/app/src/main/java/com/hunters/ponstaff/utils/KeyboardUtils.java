package com.hunters.ponstaff.utils;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

/**
 * Created by hle59 on 10/21/2016.
 */

public class KeyboardUtils {

    public void hideKeyboard(Context context)
    {
        View view = ((Activity)context).getCurrentFocus();
        if(view != null) {
            InputMethodManager imm = (InputMethodManager) context.getSystemService(context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }
}
