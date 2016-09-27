package com.hunters1984.pon.utils;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;

import com.hunters1984.pon.R;

/**
 * Created by LENOVO on 4/23/2016.
 */
public class DialogUtiils {

    private AlertDialog mAlertDialog;
    private Dialog mStaffDialog;

    public void showDialog(Context context, String message)
    {

        mAlertDialog = new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.title_alert_dialog))
                .setMessage(message)
                .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                })
                .show();

    }



}
