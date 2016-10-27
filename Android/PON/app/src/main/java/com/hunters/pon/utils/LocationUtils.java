package com.hunters.pon.utils;

import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.provider.Settings;

import com.hunters.pon.R;
import com.hunters.pon.protocols.OnDialogButtonConfirm;

/**
 * Created by hle59 on 10/27/2016.
 */

public class LocationUtils {


    public void enableLocation(final Context context) {
        LocationManager lm = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
        boolean gps_enabled = false;
        boolean network_enabled = false;

        try {
            gps_enabled = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
        } catch(Exception ex) {}

        try {
            network_enabled = lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        } catch(Exception ex) {}

        if(!gps_enabled && !network_enabled) {

            String message = context.getResources().getString(R.string.location_request);
            String btnPosCap = context.getResources().getString(R.string.open);
            String btnNegCap = context.getResources().getString(R.string.cancel);

            new DialogUtiils().showOptionDialog(context, message, btnPosCap, btnNegCap, new OnDialogButtonConfirm() {
                @Override
                public void onDialogButtonConfirm() {
                    Intent myIntent = new Intent( Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    context.startActivity(myIntent);
                }
            });
        }
    }
}
