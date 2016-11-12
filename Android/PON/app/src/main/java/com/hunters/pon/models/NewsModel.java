package com.hunters.pon.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by LENOVO on 9/18/2016.
 */
public class NewsModel {

    @SerializedName("id")
    private long mId;

    @SerializedName("title")
    private String mTitle;

    @SerializedName("introduction")
    private String mIntroduction;

    @SerializedName("image_url")
    private String mUrlImage;

    @SerializedName("created_at")
    private String mTime;

    @SerializedName("description")
    private String mDescription;

    @SerializedName("news_photo_url")
    private List<String> mLstNewPhotos;

    public long getmId() {
        return mId;
    }

    public String getmTitle() {
        return mTitle;
    }

    public String getmIntroduction() {
        return mIntroduction;
    }

    public String getmUrlImage() {
        return mUrlImage;
    }

    public String getmTime() {
        return mTime;
    }

    public String getmDescription() {
        return mDescription;
    }

    public List<String> getmLstNewPhotos() {
        return mLstNewPhotos;
    }
}
