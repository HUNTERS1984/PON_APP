package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 10/3/2016.
 */

public class ResponseMapShopCoupon extends ShopModel {

    @SerializedName("shop_photo_url")
    private List<String> mLstShopPhotos;

    @SerializedName("coupons")
    private  List<CouponModel> mLstCoupons;

    public List<String> getmLstShopPhotos() {
        return mLstShopPhotos;
    }

    public void setmLstShopPhotos(List<String> mLstShopPhotos) {
        this.mLstShopPhotos = mLstShopPhotos;
    }

    public List<CouponModel> getmLstCoupons() {
        return mLstCoupons;
    }

    public void setmLstCoupons(List<CouponModel> mLstCoupons) {
        this.mLstCoupons = mLstCoupons;
    }
}
