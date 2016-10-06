package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ShopModel;

/**
 * Created by LENOVO on 10/4/2016.
 */

public class ResponseHistoryCoupon extends CouponModel {

    @SerializedName("shop")
    private ShopModel mShop;
}
