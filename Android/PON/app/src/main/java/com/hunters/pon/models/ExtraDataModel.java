package com.hunters.pon.models;

import java.io.Serializable;

/**
 * Created by hle59 on 10/18/2016.
 */

public class ExtraDataModel implements Serializable {

    private long mId = -1;
    private String mTitle;

    public long getmId() {
        return mId;
    }

    public void setmId(long mId) {
        this.mId = mId;
    }

    public String getmTitle() {
        return mTitle;
    }

    public void setmTitle(String mTitle) {
        this.mTitle = mTitle;
    }
}
