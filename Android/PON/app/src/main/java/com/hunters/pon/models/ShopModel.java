package com.hunters.pon.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class ShopModel {

    @SerializedName("id")
    private long mId;

    @SerializedName("avatar_url")
    private String mShopPhotoAvarta;

    @SerializedName("title")
    private String mShopName;

    @SerializedName("operation_start_time")
    private String mOperationStartTime;

    @SerializedName("operation_end_time")
    private String mOperationEndTime;

    @SerializedName("is_follow")
    private int mIsShopFollow;

    @SerializedName("tel")
    private String mPhone;

    @SerializedName("longitude")
    private String mLongitude;

    @SerializedName("lattitude")
    private String mLatitude;

    @SerializedName("address")
    private String mAddress;

    @SerializedName("close_date")
    private String mCloseDate;

    @SerializedName("ave_bill")
    private int mAveBudget;

    @SerializedName("help_text")
    private String mHelpDirection;

    @SerializedName("category")
    private CategoryModel mShopCat;

    public long getmId() {
        return mId;
    }

    public void setmId(long mId) {
        this.mId = mId;
    }

    public String getmShopPhotoAvarta() {
        return mShopPhotoAvarta;
    }

    public void setmShopPhotoAvarta(String mShopPhotoAvarta) {
        this.mShopPhotoAvarta = mShopPhotoAvarta;
    }

    public String getmShopName() {
        return mShopName;
    }

    public void setmShopName(String mShopName) {
        this.mShopName = mShopName;
    }

    public String getmOperationStartTime() {
        return mOperationStartTime;
    }

    public void setmOperationStartTime(String mOperationStartTime) {
        this.mOperationStartTime = mOperationStartTime;
    }

    public String getmOperationEndTime() {
        return mOperationEndTime;
    }

    public void setmOperationEndTime(String mOperationEndTime) {
        this.mOperationEndTime = mOperationEndTime;
    }

    public int getmIsShopFollow() {
        return mIsShopFollow;
    }

    public void setmIsShopFollow(int mIsShopFollow) {
        this.mIsShopFollow = mIsShopFollow;
    }

    public String getmPhone() {
        return mPhone;
    }

    public void setmPhone(String mPhone) {
        this.mPhone = mPhone;
    }

    public String getmLongitude() {
        return mLongitude;
    }

    public void setmLongitude(String mLongitude) {
        this.mLongitude = mLongitude;
    }

    public String getmLatitude() {
        return mLatitude;
    }

    public void setmLatitude(String mLatitude) {
        this.mLatitude = mLatitude;
    }

    public String getmAddress() {
        return mAddress;
    }

    public void setmAddress(String mAddress) {
        this.mAddress = mAddress;
    }

    public String getmCloseDate() {
        return mCloseDate;
    }

    public void setmCloseDate(String mCloseDate) {
        this.mCloseDate = mCloseDate;
    }

    public int getmAveBudget() {
        return mAveBudget;
    }

    public void setmAveBudget(int mAveBudget) {
        this.mAveBudget = mAveBudget;
    }

    public String getmHelpDirection() {
        return mHelpDirection;
    }

    public void setmHelpDirection(String mHelpDirection) {
        this.mHelpDirection = mHelpDirection;
    }

    public CategoryModel getmShopCat() {
        return mShopCat;
    }

    public void setmShopCat(CategoryModel mShopCat) {
        this.mShopCat = mShopCat;
    }
}
