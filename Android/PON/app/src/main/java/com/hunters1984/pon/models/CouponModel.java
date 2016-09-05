package com.hunters1984.pon.models;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class CouponModel {
    private String mImageUrl;
    private String mTitle;
    private String mDescription;
    private String mExpireDate;
    private boolean mIsFavourite;
    private boolean mIsLoginRequired;

    public boolean ismIsFavourite() {
        return mIsFavourite;
    }

    public void setmIsFavourite(boolean mIsFavourite) {
        this.mIsFavourite = mIsFavourite;
    }

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

    public String getmDescription() {
        return mDescription;
    }

    public void setmDescription(String mDescription) {
        this.mDescription = mDescription;
    }

    public String getmExpireDate() {
        return mExpireDate;
    }

    public void setmExpireDate(String mExpireDate) {
        this.mExpireDate = mExpireDate;
    }

    public boolean ismIsLoginRequired() {
        return mIsLoginRequired;
    }

    public void setmIsLoginRequired(boolean mIsLoginRequired) {
        this.mIsLoginRequired = mIsLoginRequired;
    }
}
