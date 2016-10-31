package com.hunters.ponstaff.api;

import android.content.Context;

import com.hunters.ponstaff.R;
import com.hunters.ponstaff.utils.ProgressDialogUtils;

/**
 * Created by LENOVO on 9/26/2016.
 */

public class APIHelper {
    public static final String HOST_NAME = "http://pon.cm";

    protected ProgressDialogUtils mProgressDialogUtils;

    protected void showProgressDialog(Context context) {

        if(mProgressDialogUtils == null) {
            mProgressDialogUtils = new ProgressDialogUtils(context, "", context.getString(R.string.connecting));
        }
        mProgressDialogUtils.show();
    }

    protected void closeDialog() {
        if(mProgressDialogUtils != null){
            mProgressDialogUtils.hide();
        }
    }

}
