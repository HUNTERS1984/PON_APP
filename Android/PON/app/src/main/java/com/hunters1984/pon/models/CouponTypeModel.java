package com.hunters1984.pon.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class CouponTypeModel {

    @SerializedName("id")
    private double mId;

    @SerializedName("name")
    private String mName;

    @SerializedName("icon_url")
    private String mIcon;

    public double getmId() {
        return mId;
    }

    public void setmId(double mId) {
        this.mId = mId;
    }

    public String getmName() {
        return mName;
    }

    public void setmName(String mName) {
        this.mName = mName;
    }

    public String getmIcon() {
        return mIcon;
    }

    public void setmIcon(String mIcon) {
        this.mIcon = mIcon;
    }
}
