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

    @SerializedName("link")
    private String mFacebookLinkShare;

    @SerializedName("coupon_id")
    private String mCouponId;

    @SerializedName("twitter_sharing")
    private String mTwitterLinkShare;

    @SerializedName("instagram_sharing")
    private String mInstagramLinkShare;

    @SerializedName("line_sharing")
    private String mLineLinkShare;

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

    public String getmFacebookLinkShare() {
        return mFacebookLinkShare;
    }

    public void setmFacebookLinkShare(String mLinkShare) {
        this.mFacebookLinkShare = mLinkShare;
    }

    public String getmCouponId() {
        return mCouponId;
    }

    public void setmCouponId(String mCouponId) {
        this.mCouponId = mCouponId;
    }

    public String getmTwitterLinkShare() {
        return mTwitterLinkShare;
    }

    public String getmInstagramLinkShare() {
        return mInstagramLinkShare;
    }

    public String getmLineLinkShare() {
        return mLineLinkShare;
    }

    public void setmTwitterLinkShare(String mTwitterLinkShare) {
        this.mTwitterLinkShare = mTwitterLinkShare;
    }

    public void setmInstagramLinkShare(String mInstagramLinkShare) {
        this.mInstagramLinkShare = mInstagramLinkShare;
    }

    public void setmLineLinkShare(String mLineLinkShare) {
        this.mLineLinkShare = mLineLinkShare;
    }
}
