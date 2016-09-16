package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import com.hunters1984.pon.R;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class EditProfileActivity extends BaseActivity implements OnLoadDataListener {

    private Spinner mSpnSex, mSpnPrefecture;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_edit_profile);
        mContext = this;
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.edit_profile));

        initLayout();
    }


    @Override
    public void onLoadData() {

    }

    private void initLayout()
    {
        mSpnSex = (Spinner)findViewById(R.id.spn_sex);

        List<String> sex = new ArrayList<String>();
        sex.add(getString(R.string.male));
        sex.add(getString(R.string.female));

        ArrayAdapter<String> sexAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sex);
        sexAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mSpnSex.setAdapter(sexAdapter);

        mSpnSex = (Spinner)findViewById(R.id.spn_prefecture);

        List<String> prefectures = new ArrayList<String>();
        prefectures.add("東京都");
        prefectures.add("大阪ジャパン");

        // Creating adapter for spinner
        ArrayAdapter<String> prefectureAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, prefectures);
        prefectureAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mSpnSex.setAdapter(prefectureAdapter);
    }
}
