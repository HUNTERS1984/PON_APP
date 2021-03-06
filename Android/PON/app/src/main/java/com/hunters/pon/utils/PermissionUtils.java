package com.hunters.pon.utils;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;

import com.hunters.pon.R;
import com.hunters.pon.protocols.OnDialogButtonConfirm;

/**
 * Created by LENOVO on 9/7/2016.
 */
public class PermissionUtils {

    public static final int REQUEST_WRITE_EXTERNAL_STORAGE = 1;
    public static final int REQUEST_LOCATION = 2;
    public static final int REQUEST_CAMERA_AND_STORAGE = 3;
    public static final int REQUEST_PHONE_CALL = 3;

    private static PermissionUtils instance;

    public static PermissionUtils newInstance()
    {
        if(instance == null) {
            instance = new PermissionUtils();
        }
        return instance;
    }

    public boolean isGrantLocationPermission(Activity context) {

        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            return false;
        }

        return true;
    }

    public void requestLocationPermission(final Activity context) {

        if (ActivityCompat.shouldShowRequestPermissionRationale(context,Manifest.permission.ACCESS_FINE_LOCATION)) {

            new DialogUtiils().showDialog(context, context.getString(R.string.location_request), new OnDialogButtonConfirm() {

                @Override
                public void onDialogButtonConfirm() {
                    ActivityCompat.requestPermissions(context,
                            new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                            REQUEST_LOCATION);
                }
            });
        } else {
            ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    REQUEST_LOCATION);
        }
    }

    public boolean isGrantStoragePermission(Activity context)
    {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
                || ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            return false;
        }

        return true;
    }

    public void requestStoragePermission(final Activity context) {

        if (ActivityCompat.shouldShowRequestPermissionRationale(context,Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

            new DialogUtiils().showDialog(context, context.getString(R.string.storage_request), new OnDialogButtonConfirm() {

                @Override
                public void onDialogButtonConfirm() {
                    ActivityCompat.requestPermissions(context,
                            new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                            REQUEST_WRITE_EXTERNAL_STORAGE);
                }
            });
        } else {
            ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    REQUEST_WRITE_EXTERNAL_STORAGE);
        }
    }

    public boolean isGrantCameraAndStoragePermission(Activity context)
    {
        if ((ActivityCompat.checkSelfPermission(context, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
                || ActivityCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            return false;
        }

        return true;
    }

    public void requestCameraAndStoragePermission(final Activity context) {

        if (ActivityCompat.shouldShowRequestPermissionRationale(context,Manifest.permission.CAMERA) ||
                ActivityCompat.shouldShowRequestPermissionRationale(context,Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

            new DialogUtiils().showDialog(context, context.getString(R.string.camera_and_storage_request), new OnDialogButtonConfirm() {

                @Override
                public void onDialogButtonConfirm() {
                    ActivityCompat.requestPermissions(context,
                            new String[]{Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE},
                            REQUEST_CAMERA_AND_STORAGE);
                }
            });
        } else {
            ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    REQUEST_CAMERA_AND_STORAGE);
        }
    }

    public boolean isGrantPhoneCallPermission(Activity context)
    {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            return false;
        }

        return true;
    }

    public void requestPhoneCallPermission(final Activity context) {

        if (ActivityCompat.shouldShowRequestPermissionRationale(context,Manifest.permission.CALL_PHONE)) {

            new DialogUtiils().showDialog(context, context.getString(R.string.phone_call_request), new OnDialogButtonConfirm() {

                @Override
                public void onDialogButtonConfirm() {
                    ActivityCompat.requestPermissions(context,
                            new String[]{Manifest.permission.CALL_PHONE},
                            REQUEST_PHONE_CALL);
                }
            });
        } else {
            ActivityCompat.requestPermissions(context, new String[]{Manifest.permission.CALL_PHONE},
                    REQUEST_PHONE_CALL);
        }
    }
}
