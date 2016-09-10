package com.hunters1984.pon.activities;

import android.app.Activity;
import android.os.Bundle;

import com.hunters1984.pon.R;
import com.hunters1984.pon.protocols.OnLoadDataListener;

public class EditProfileActivity extends Activity implements OnLoadDataListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_edit_profile);
//        mContext = this;
        super.onCreate(savedInstanceState);

    }


    @Override
    public void onLoadData() {

    }
}
