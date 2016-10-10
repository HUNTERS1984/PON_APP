package com.hunters.pon.models;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class CouponModel implements Serializable {

    @SerializedName("id")
    private long mId;

    @SerializedName("image_url")
    private String mImageUrl;

    @SerializedName("title")
    private String mTitle;

    @SerializedName("expired_time")
    private String mExpireDate;

    @SerializedName("is_like")
    private int mIsFavourite;

    @SerializedName("need_login")
    private int mIsLoginRequired;

    @SerializedName("can_use")
    private int mCanUse;

    @SerializedName("coupon_type")
    private CouponTypeModel mCouponType;

    @SerializedName("code")
    private String mCode;

    @SerializedName("description")
    private String mDescription;

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

    public long getmId() {
        return mId;
    }

    public void setmId(long mId) {
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

    public CouponTypeModel getmCouponType() {
        return mCouponType;
    }

    public void setmCouponType(CouponTypeModel mCouponType) {
        this.mCouponType = mCouponType;
    }

    public String getmCode() {
        return mCode;
    }

    public void setmCode(String mCode) {
        this.mCode = mCode;
    }

    public String getmDescription() {
        return mDescription;
    }

    public void setmDescription(String mDescription) {
        this.mDescription = mDescription;
    }
}