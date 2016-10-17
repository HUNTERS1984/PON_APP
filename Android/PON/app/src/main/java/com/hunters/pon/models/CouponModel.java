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
    private boolean mIsFavourite;

    @SerializedName("need_login")
    private boolean mIsLoginRequired;

    @SerializedName("can_use")
    private boolean mCanUse;

    @SerializedName("coupon_type")
    private CouponTypeModel mCouponType;

    @SerializedName("code")
    private String mCode;

    @SerializedName("description")
    private String mDescription;

    private boolean mIsUsed = false;

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

    public boolean getmIsFavourite() {
        return mIsFavourite;
    }

    public void setmIsFavourite(boolean mIsFavourite) {
        this.mIsFavourite = mIsFavourite;
    }

    public boolean getmIsLoginRequired() {
        return mIsLoginRequired;
    }

    public void setmIsLoginRequired(boolean mIsLoginRequired) {
        this.mIsLoginRequired = mIsLoginRequired;
    }

    public boolean getmCanUse() {
        return mCanUse;
    }

    public void setmCanUse(boolean mCanUse) {
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

    public boolean ismIsUsed() {
        return mIsUsed;
    }

    public void setmIsUsed(boolean mIsUsed) {
        this.mIsUsed = mIsUsed;
    }
}
