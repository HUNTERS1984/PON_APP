package com.hunters1984.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.ResponseUserData;
import com.hunters1984.pon.api.UserProfileAPIHelper;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.hunters1984.pon.utils.DialogUtiils;

public class SignInEmailActivity extends BaseActivity {

    private static final int REQUEST_CODE = 1;

    private Button mBtnLogin;
    private EditText mEdtUsername, mEdtPassword;
    private TextView mTvNewMemberRegistration;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        mContext = this;
        setContentView(R.layout.activity_sign_in_email);
        super.onCreate(savedInstanceState);

        initLayout();
    }

    private void initLayout()
    {
        setIconBack(R.drawable.ic_close);
        setTitle(getString(R.string.login));

        mEdtUsername = (EditText)findViewById(R.id.edt_username);
        mEdtPassword = (EditText) findViewById(R.id.edt_password);

        mBtnLogin = (Button) findViewById(R.id.btn_login);
        mBtnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String username = mEdtUsername.getText().toString();
                String password = mEdtPassword.getText().toString();
                new UserProfileAPIHelper().signIn(mContext, username, password, mHanlderSignIn);
            }
        });

        mTvNewMemberRegistration = (TextView)findViewById(R.id.tv_new_member_registration);
        mTvNewMemberRegistration.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivityForResult(SignInEmailActivity.this, SignUpEmailActivity.class, REQUEST_CODE);
            }
        });
    }

    private Handler mHanlderSignIn = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            ResponseUserData user = (ResponseUserData) msg.obj;
            if (user.code != APIConstants.REQUEST_OK) {
                new DialogUtiils().showDialog(mContext, user.message, false);
            } else {
                CommonUtils.saveToken(mContext, user.data.token);
                Intent iMainScreen = new Intent(SignInEmailActivity.this, MainTopActivity.class);
                iMainScreen.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(iMainScreen);
                finish();
            }
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (requestCode == REQUEST_CODE) {
            if(resultCode == Activity.RESULT_OK){
                String username = data.getStringExtra(Constants.EXTRA_USER_NAME);
                mEdtUsername.setText(username);
            }
        }
    }
}
