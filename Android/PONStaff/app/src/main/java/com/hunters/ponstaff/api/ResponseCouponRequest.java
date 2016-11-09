package com.hunters.ponstaff.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.ponstaff.models.CouponModel;
import com.hunters.ponstaff.models.UserModel;

/**
 * Created by hle59 on 10/31/2016.
 */

public class ResponseCouponRequest {

    @SerializedName("user")
    private UserModel mUser;

    @SerializedName("coupon")
    private CouponModel mCouponRequest;

    @SerializedName("code")
    private String mCode;

    @SerializedName("requested_at")
    private String mTimeRequest;

    public UserModel getmUser() {
        return mUser;
    }

    public CouponModel getmCouponRequest() {
        return mCouponRequest;
    }

    public String getmCode() {
        return mCode;
    }

    public String getmTimeRequest() {
        return mTimeRequest;
    }
}
