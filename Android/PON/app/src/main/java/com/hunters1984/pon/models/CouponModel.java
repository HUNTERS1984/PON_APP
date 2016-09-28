package com.hunters1984.pon.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class CouponModel {

    @SerializedName("id")
    private double mId;

    @SerializedName("image_url")
    private String mImageUrl;

    @SerializedName("title")
    private String mTitle;

    @SerializedName("expired_time")
    private String mExpireDate;

    @SerializedName("is_like")
    private int mIsFavourite;

    @SerializedName("")
    private int mIsLoginRequired;

    @SerializedName("can_use")
    private int mCanUse;

    private String mType;

    public String getmImageUrl() {
        return mImageUrl;
    }

    public void setmImageUrl(String mImageUrl) {
        this.mImageUrl = mImageUrl;
    }

    public String getmTitle() {
        return mTitle;
    }

    public void setmTitle(String mTitle) {
        this.mTitle = mTitle;
    }


    public String getmExpireDate() {
        return mExpireDate;
    }

    public void setmExpireDate(String mExpireDate) {
        this.mExpireDate = mExpireDate;
    }

    public double getmId() {
        return mId;
    }

    public void setmId(double mId) {
        this.mId = mId;
    }

    public int getmIsFavourite() {
        return mIsFavourite;
    }

    public void setmIsFavourite(int mIsFavourite) {
        this.mIsFavourite = mIsFavourite;
    }

    public int getmIsLoginRequired() {
        return mIsLoginRequired;
    }

    public void setmIsLoginRequired(int mIsLoginRequired) {
        this.mIsLoginRequired = mIsLoginRequired;
    }

    public int getmCanUse() {
        return mCanUse;
    }

    public void setmCanUse(int mCanUse) {
        this.mCanUse = mCanUse;
    }

    public String getmType() {
        return mType;
    }

    public void setmType(String mType) {
        this.mType = mType;
    }
}
