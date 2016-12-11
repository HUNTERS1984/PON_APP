package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseUserData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.KeyboardUtils;

public class SignInEmailActivity extends BaseActivity {

    private static final int REQUEST_CODE = 1;

    private Button mBtnLogin;
    private EditText mEdtUsername, mEdtPassword;
    private TextView mTvNewMemberRegistration, mTvResetPassword;

    private ExtraDataModel mDataExtra;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        mContext = this;
        setContentView(R.layout.activity_sign_in_email);
        super.onCreate(savedInstanceState);

        mDataExtra = (ExtraDataModel)getIntent().getSerializableExtra(Constants.EXTRA_DATA);

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
                if(username.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_username), false);
                    return;
                }
                if(password.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_password), false);
                    return;
                }

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

        mTvResetPassword = (TextView)findViewById(R.id.tv_reset_password);
        mTvResetPassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, ResetPasswordActivity.class, false);
            }
        });

    }

    private Handler mHanlderSignIn = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            new KeyboardUtils().hideKeyboard(mContext);
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseUserData user = (ResponseUserData) msg.obj;
                    if (user.code == APIConstants.REQUEST_OK && user.httpCode == APIConstants.HTTP_OK) {
                        CommonUtils.saveToken(mContext, user.data.token);
                        CommonUtils.setLoginType(mContext, Constants.LOGIN_EMAIL);
                        if(mDataExtra == null) {
                            Intent iMainScreen = new Intent(SignInEmailActivity.this, MainTopActivity.class);
                            iMainScreen.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                            startActivity(iMainScreen);
                        } else {
                            setResult(Activity.RESULT_OK);
                        }
                        finish();
                    } else {
                        new DialogUtiils().showDialog(mContext, user.message, false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
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
