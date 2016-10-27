package com.hunters.pon.utils;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.hunters.pon.R;
import com.hunters.pon.activities.SplashActivity;
import com.hunters.pon.protocols.OnDialogButtonConfirm;

import java.util.List;

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

    public void showOptionDialog(final Context context, String message, String btnPositiveCaption, String btnNegativeCaption, final OnDialogButtonConfirm buttonConfirm)
    {

        mAlertDialog = new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.title_alert_dialog))
                .setMessage(message)
                .setPositiveButton(btnPositiveCaption, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        buttonConfirm.onDialogButtonConfirm();
                        dialog.dismiss();

                    }
                })
                .setNegativeButton(btnNegativeCaption, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();

                    }
                })
                .show();

    }

    public void showDialogLogin(final Context context, String message)
    {

        mAlertDialog = new AlertDialog.Builder(context)
                .setTitle(context.getString(R.string.title_alert_dialog))
                .setMessage(message)
                .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();

                    }
                }).setPositiveButton(R.string.login, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        Intent iLogin = new Intent(context, SplashActivity.class);
                        iLogin.putExtra(Constants.EXTRA_DATA, false);
                        context.startActivity(iLogin);
                    }
                })
                .show();

    }

    public void showStaffDialog(final Context context, List<String> lstStaffs, final Handler handler)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle("STAFF");
        final ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(
                context,
                R.layout.custom_select_dialog_item);
        arrayAdapter.addAll(lstStaffs);

        builder.setNegativeButton(
                "Cancel",
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });

        builder.setAdapter(
                arrayAdapter,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String name = arrayAdapter.getItem(which);
                        Message msg = Message.obtain();
                        msg.obj = name;
                        handler.sendMessage(msg);
                        dialog.dismiss();
                    }
                });
        final AlertDialog dialog =  builder.create();
        ListView listView = dialog.getListView();
        listView.setDivider(new ColorDrawable(ContextCompat.getColor(context, R.color.grey))); // set color
        listView.setDividerHeight(1);
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override
            public void onShow(DialogInterface arg0) {
                dialog.getButton(AlertDialog.BUTTON_NEGATIVE).setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
            }
        });
        dialog.show();
    }

}
