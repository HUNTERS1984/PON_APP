package com.hunters1984.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 10/1/2016.
 */

public class ResponseShopDetail extends ShopModel {

    @SerializedName("shop_photo_url")
    List<String> mLstShopPhoto;

    @SerializedName("coupons")
    List<CouponModel> mLstCouponOfShop;

    public List<String> getmLstShopPhoto() {
        return mLstShopPhoto;
    }

    public void setmLstShopPhoto(List<String> mLstShopPhoto) {
        this.mLstShopPhoto = mLstShopPhoto;
    }

    public List<CouponModel> getmLstCouponOfShop() {
        return mLstCouponOfShop;
    }

    public void setmLstCouponOfShop(List<CouponModel> mLstCouponOfShop) {
        this.mLstCouponOfShop = mLstCouponOfShop;
    }
}
