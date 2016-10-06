package com.hunters.pon.utils;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;

import com.hunters.pon.R;
import com.hunters.pon.protocols.OnDialogButtonConfirm;

/**
 * Created by LENOVO on 4/23/2016.
 */
public class DialogUtiils {

    private AlertDialog mAlertDialog;
    private Dialog mStaffDialog;

    public void showDialog(final Context context, String message, final boolean isCloseScreen)
    {

        mAlertDialog = new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.title_alert_dialog))
                .setMessage(message)
                .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        if(isCloseScreen) {
                            ((Activity) context).finish();
                        }
                        dialog.dismiss();

                    }
                })
                .show();

    }

    public void showDialog(final Context context, String message, final OnDialogButtonConfirm buttonConfirm)
    {

        mAlertDialog = new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.title_alert_dialog))
                .setMessage(message)
                .setNegativeButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        buttonConfirm.onDialogButtonConfirm();
                        dialog.dismiss();

                    }
                })
                .show();

    }


}
