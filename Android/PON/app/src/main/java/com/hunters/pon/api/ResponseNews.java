package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CategoryModel;
import com.hunters.pon.models.NewsModel;
import com.hunters.pon.models.ShopModel;

/**
 * Created by LENOVO on 11/12/2016.
 */

public class ResponseNews extends NewsModel {

    @SerializedName("shop")
    private ShopModel mShop;

    @SerializedName("category")
    private CategoryModel mCategory;

    public ShopModel getmShop() {
        return mShop;
    }

    public CategoryModel getmCategory() {
        return mCategory;
    }
}
