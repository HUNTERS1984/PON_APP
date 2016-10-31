package com.hunters.ponstaff.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 10/3/2016.
 */

public class CouponTypeModel {

    @SerializedName("id")
    private long mId;

    @SerializedName("name")
    private String mName;

    public long getmId() {
        return mId;
    }

    public void setmId(long mId) {
        this.mId = mId;
    }

    public String getmName() {
        return mName;
    }

    public void setmName(String mName) {
        this.mName = mName;
    }
}
