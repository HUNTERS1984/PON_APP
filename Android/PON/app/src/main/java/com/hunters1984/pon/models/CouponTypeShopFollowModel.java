package com.hunters1984.pon.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 9/30/2016.
 */

public class CouponTypeShopFollowModel {

    @SerializedName("id")
    private double mCouponTypeId;

    @SerializedName("name")
    private String mCouponTypeName;

    @SerializedName("shop_count")
    private String mShopBelongCount;

    @SerializedName("icon_url")
    private String mCouponTypeIconUrl;

    public double getmCouponTypeId() {
        return mCouponTypeId;
    }

    public void setmCouponTypeId(double mCouponTypeId) {
        this.mCouponTypeId = mCouponTypeId;
    }

    public String getmCouponTypeName() {
        return mCouponTypeName;
    }

    public void setmCouponTypeName(String mCouponTypeName) {
        this.mCouponTypeName = mCouponTypeName;
    }

    public String getmShopBelongCount() {
        return mShopBelongCount;
    }

    public void setmShopBelongCount(String mShopBelongCount) {
        this.mShopBelongCount = mShopBelongCount;
    }

    public String getmCouponTypeIconUrl() {
        return mCouponTypeIconUrl;
    }

    public void setmCouponTypeIconUrl(String mCouponTypeIconUrl) {
        this.mCouponTypeIconUrl = mCouponTypeIconUrl;
    }
}
