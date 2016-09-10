package com.hunters1984.pon.activities;

import android.os.Bundle;

import com.hunters1984.pon.R;
import com.hunters1984.pon.protocols.OnLoadDataListener;

public class EditProfileActivity extends BaseActivity implements OnLoadDataListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_edit_profile);
        mContext = this;
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.title_edit_profile));

    }


    @Override
    public void onLoadData() {

    }
}
