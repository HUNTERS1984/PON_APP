package com.hunters1984.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters1984.pon.models.CouponModel;

import java.util.List;

/**
 * Created by LENOVO on 9/28/2016.
 */

public class ResponseCouponMainTop {

    @SerializedName("id")
    String mId;

    @SerializedName("name")
    String mTypeName;

    @SerializedName("icon_url")
    String mIconUrl;

    @SerializedName("coupons")
    List<CouponModel> mLstCoupons;

    public String getmId() {
        return mId;
    }

    public void setmId(String mId) {
        this.mId = mId;
    }

    public String getmTypeName() {
        return mTypeName;
    }

    public void setmTypeName(String mTypeName) {
        this.mTypeName = mTypeName;
    }

    public String getmIconUrl() {
        return mIconUrl;
    }

    public void setmIconUrl(String mIconUrl) {
        this.mIconUrl = mIconUrl;
    }

    public List<CouponModel> getmLstCoupons() {
        return mLstCoupons;
    }

    public void setmLstCoupons(List<CouponModel> mLstCoupons) {
        this.mLstCoupons = mLstCoupons;
    }
}
