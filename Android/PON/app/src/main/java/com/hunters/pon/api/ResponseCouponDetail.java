package com.hunters.pon.api;

import com.google.gson.annotations.SerializedName;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.CouponTypeModel;
import com.hunters.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class ResponseCouponDetail {
    @SerializedName("id")
    private long mId;

    @SerializedName("image_url")
    private String mImageUrl;

    @SerializedName("title")
    private String mTitle;

    @SerializedName("description")
    private String mDescription;

    @SerializedName("expired_time")
    private String mExpireDate;

    @SerializedName("is_like")
    private byte mIsFavourite;

    @SerializedName("can_use")
    private byte mCanUse;

    @SerializedName("code")
    private String mCode;

    @SerializedName("shop")
    ShopModel mShop;

    @SerializedName("coupon_type")
    CouponTypeModel mCouponType;

    @SerializedName("coupon_photo_url")
    List<String> mLstPhotoCoupons;

    @SerializedName("user_photo_url")
    List<String> mLstPhotoUsers;

    @SerializedName("similar_coupon")
    List<CouponModel> mLstSimilarCoupons;

    public long getmId() {
        return mId;
    }

    public void setmId(long mId) {
        this.mId = mId;
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

    public byte getmIsFavourite() {
        return mIsFavourite;
    }

    public void setmIsFavourite(byte mIsFavourite) {
        this.mIsFavourite = mIsFavourite;
    }

    public byte getmCanUse() {
        return mCanUse;
    }

    public void setmCanUse(byte mCanUse) {
        this.mCanUse = mCanUse;
    }

    public String getmCode() {
        return mCode;
    }

    public void setmCode(String mCode) {
        this.mCode = mCode;
    }

    public ShopModel getmShop() {
        return mShop;
    }

    public void setmShop(ShopModel mShop) {
        this.mShop = mShop;
    }

    public CouponTypeModel getmCouponType() {
        return mCouponType;
    }

    public void setmCouponType(CouponTypeModel mCouponType) {
        this.mCouponType = mCouponType;
    }

    public List<String> getmLstPhotoCoupons() {
        return mLstPhotoCoupons;
    }

    public void setmLstPhotoCoupons(List<String> mLstPhotoCoupons) {
        this.mLstPhotoCoupons = mLstPhotoCoupons;
    }

    public List<String> getmLstPhotoUsers() {
        return mLstPhotoUsers;
    }

    public void setmLstPhotoUsers(List<String> mLstPhotoUsers) {
        this.mLstPhotoUsers = mLstPhotoUsers;
    }

    public List<CouponModel> getmLstSimilarCoupons() {
        return mLstSimilarCoupons;
    }

    public void setmLstSimilarCoupons(List<CouponModel> mLstSimilarCoupons) {
        this.mLstSimilarCoupons = mLstSimilarCoupons;
    }
}
