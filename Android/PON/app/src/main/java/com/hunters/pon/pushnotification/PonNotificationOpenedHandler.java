package com.hunters.pon.pushnotification;

import android.content.Context;
import android.content.Intent;

import com.hunters.pon.activities.CouponDetailActivity;
import com.hunters.pon.utils.Constants;
import com.onesignal.OSNotificationAction;
import com.onesignal.OSNotificationOpenResult;
import com.onesignal.OneSignal;

import org.json.JSONObject;

/**
 * Created by LENOVO on 10/9/2016.
 */

public class PonNotificationOpenedHandler implements OneSignal.NotificationOpenedHandler {

    private Context mContext;

    public PonNotificationOpenedHandler(Context context) {
        mContext = context;
    }

    @Override
    public void notificationOpened(OSNotificationOpenResult result) {
        OSNotificationAction.ActionType actionType = result.action.type;
        JSONObject data = result.notification.payload.additionalData;

//        Log.d("HUY", data.toString());
        if (data != null) {
            String notificationType = data.optString("notification_type", null);
            long id = data.optLong("id");

            if (notificationType != null) {
                if(notificationType.equalsIgnoreCase(Constants.NOTIFICATION_NEW_COUPON)){
                    Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                    iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, id);
                    iCouponDetail.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_NEW_TASK);
                    mContext.startActivity(iCouponDetail);
                }
            }

        }

//        Log.i("OneSignalExample", "Button pressed with id: " + result.action.actionID);
//
//        if (actionType == OSNotificationAction.ActionType.ActionTaken) {
//
//        }
//            Log.i("OneSignalExample", "Button pressed with id: " + result.action.actionID);

        // The following can be used to open an Activity of your choice.
        // Replace - getApplicationContext() - with any Android Context.
        // Intent intent = new Intent(getApplicationContext(), YourActivity.class);
        // intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_NEW_TASK);
        // startActivity(intent);

        // Add the following to your AndroidManifest.xml to prevent the launching of your main Activity
        //   if you are calling startActivity above.
     /*
        <application ...>
          <meta-data android:name="com.onesignal.NotificationOpened.DEFAULT" android:value="DISABLE" />
        </application>
     */
  }

}
