package com.hunters.pon.models;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by LENOVO on 9/26/2016.
 */

public class UserModel implements Serializable {
    @SerializedName("id")
    private int mId;

    @SerializedName("name")
    private String mName;

    @SerializedName("username")
    private String mUsername;

    @SerializedName("email")
    private String mEmail;

    @SerializedName("gender")
    private int mGender;

    @SerializedName("address")
    private String mAddress;

    @SerializedName("avatar_url")
    private String mAvatarUrl;

    @SerializedName("follow_number")
    private String mFollowShopNumber;

    @SerializedName("used_number")
    private String mCouponUsedNumber;

    @SerializedName("news_number")
    private String mNewsNumber;

    public int getmId() {
        return mId;
    }

    public void setmId(int mId) {
        this.mId = mId;
    }

    public String getmName() {
        return mName;
    }

    public void setmName(String mName) {
        this.mName = mName;
    }

    public int getmGender() {
        return mGender;
    }

    public void setmGender(int mGender) {
        this.mGender = mGender;
    }

    public String getmAddress() {
        return mAddress;
    }

    public void setmAddress(String mAddress) {
        this.mAddress = mAddress;
    }

    public String getmAvatarUrl() {
        return mAvatarUrl;
    }

    public void setmAvatarUrl(String mAvatarUrl) {
        this.mAvatarUrl = mAvatarUrl;
    }

    public String getmUsername() {
        return mUsername;
    }

    public void setmUsername(String mUsername) {
        this.mUsername = mUsername;
    }

    public String getmEmail() {
        return mEmail;
    }

    public void setmEmail(String mEmail) {
        this.mEmail = mEmail;
    }

    public String getmFollowShopNumber() {
        return mFollowShopNumber;
    }

    public void setmFollowShopNumber(String mFollowShopNumber) {
        this.mFollowShopNumber = mFollowShopNumber;
    }

    public String getmCouponUsedNumber() {
        return mCouponUsedNumber;
    }

    public void setmCouponUsedNumber(String mCouponUsedNumber) {
        this.mCouponUsedNumber = mCouponUsedNumber;
    }

    public String getmNewsNumber() {
        return mNewsNumber;
    }

    public void setmNewsNumber(String mNewsNumber) {
        this.mNewsNumber = mNewsNumber;
    }
}
