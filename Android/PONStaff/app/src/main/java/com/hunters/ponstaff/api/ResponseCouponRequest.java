package com.hunters.ponstaff.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.ponstaff.models.CouponModel;
import com.hunters.ponstaff.models.UserModel;

import java.util.List;

/**
 * Created by hle59 on 10/31/2016.
 */

public class ResponseCouponRequest extends CouponModel {

    @SerializedName("users")
    private List<UserModel> mUser;

    public List<UserModel> getmUser() {
        return mUser;
    }
}
