package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CategoryModel;
import com.hunters.pon.models.CouponModel;

import java.util.List;

/**
 * Created by LENOVO on 10/3/2016.
 */

public class ResponseCouponByCategory extends CategoryModel{

    @SerializedName("coupons")
    List<CouponModel> mLstCoupons;

    public List<CouponModel> getmLstCoupons() {
        return mLstCoupons;
    }

    public void setmLstCoupons(List<CouponModel> mLstCoupons) {
        this.mLstCoupons = mLstCoupons;
    }
}
