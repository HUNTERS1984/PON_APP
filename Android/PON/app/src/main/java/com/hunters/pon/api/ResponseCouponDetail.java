package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class ResponseCouponDetail extends  CouponModel {


    @SerializedName("shop")
    ShopModel mShop;

    @SerializedName("coupon_photo_url")
    List<String> mLstPhotoCoupons;

    @SerializedName("user_photo_url")
    List<String> mLstPhotoUsers;

    @SerializedName("similar_coupon")
    List<CouponModel> mLstSimilarCoupons;

    public ShopModel getmShop() {
        return mShop;
    }

    public void setmShop(ShopModel mShop) {
        this.mShop = mShop;
    }

     public List<String> getmLstPhotoCoupons() {
        return mLstPhotoCoupons;
    }

    public void setmLstPhotoCoupons(List<String> mLstPhotoCoupons) {
        this.mLstPhotoCoupons = mLstPhotoCoupons;
    }

    public List<String> getmLstPhotoUsers() {
        return mLstPhotoUsers;
    }

    public void setmLstPhotoUsers(List<String> mLstPhotoUsers) {
        this.mLstPhotoUsers = mLstPhotoUsers;
    }

    public List<CouponModel> getmLstSimilarCoupons() {
        return mLstSimilarCoupons;
    }

    public void setmLstSimilarCoupons(List<CouponModel> mLstSimilarCoupons) {
        this.mLstSimilarCoupons = mLstSimilarCoupons;
    }
}
