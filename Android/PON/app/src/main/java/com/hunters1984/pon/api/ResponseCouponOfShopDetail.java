package com.hunters1984.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.models.CouponTypeModel;

/**
 * Created by LENOVO on 10/1/2016.
 */

public class ResponseCouponOfShopDetail extends CouponModel {

    @SerializedName("coupon_type")
    private CouponTypeModel mCouponType;

    public CouponTypeModel getmCouponType() {
        return mCouponType;
    }

    public void setmCouponType(CouponTypeModel mCouponType) {
        this.mCouponType = mCouponType;
    }
}
