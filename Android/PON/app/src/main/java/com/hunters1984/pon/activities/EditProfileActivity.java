package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import com.hunters1984.pon.R;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.ResponseProfileData;
import com.hunters1984.pon.api.UserProfileAPIHelper;
import com.hunters1984.pon.models.UserModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class EditProfileActivity extends BaseActivity implements OnLoadDataListener {

    private Spinner mSpnSex, mSpnPrefecture;
    private EditText mEdtUserName, mEdtEmail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_edit_profile);
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.edit_profile));

        initLayout();
    }


    @Override
    public void onLoadData() {
            new UserProfileAPIHelper().getProfile(mContext, mHanlderGetProfile);
    }

    private void initLayout()
    {
        mEdtUserName = (EditText) findViewById(R.id.edt_username);
        mEdtEmail = (EditText) findViewById(R.id.edt_email);

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

    private Handler mHanlderGetProfile = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:

                    ResponseProfileData profile = (ResponseProfileData) msg.obj;
                    if (profile.code == APIConstants.REQUEST_OK && profile.httpCode == APIConstants.HTTP_OK) {
                        UserModel user = profile.data;
                        popularUI(user);
                    } else {

                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private void popularUI(UserModel user)
    {
        mEdtUserName.setText(user.getmUsername());
        mEdtEmail.setText(user.getmEmail());
    }
}
