package com.hunters.pon.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by LENOVO on 10/22/2016.
 */

public class PaginationModel {

    @SerializedName("limit")
    private String mLimit;

    @SerializedName("offset")
    private int mOffset;

    @SerializedName("item_total")
    private int mItemTotal;

    @SerializedName("page_total")
    private int mPageTotal;

    @SerializedName("current_page")
    private int mCurrentPage;

    public String getmLimit() {
        return mLimit;
    }

    public void setmLimit(String mLimit) {
        this.mLimit = mLimit;
    }

    public int getmOffset() {
        return mOffset;
    }

    public void setmOffset(int mOffset) {
        this.mOffset = mOffset;
    }

    public int getmItemTotal() {
        return mItemTotal;
    }

    public void setmItemTotal(int mItemTotal) {
        this.mItemTotal = mItemTotal;
    }

    public int getmPageTotal() {
        return mPageTotal;
    }

    public void setmPageTotal(int mPageTotal) {
        this.mPageTotal = mPageTotal;
    }

    public int getmCurrentPage() {
        return mCurrentPage;
    }

    public void setmCurrentPage(int mCurrentPage) {
        this.mCurrentPage = mCurrentPage;
    }
}
