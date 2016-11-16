package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Context;
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
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.protocols.OnDialogButtonConfirm;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

public class SignUpEmailActivity extends BaseActivity implements OnDialogButtonConfirm {

    private Button mBtnSignUp;
    private TextView mTvBackToLogin;
    private EditText mEdtUsername, mEdtEmail, mEdtPassword, mEdtPasswordConfirm;
    private Context mContext;
    private OnDialogButtonConfirm mDialogConfirm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_sign_up_email);
        super.onCreate(savedInstanceState);
        mContext = this;
        mDialogConfirm = this;
        initLayout();
    }

    private void initLayout()
    {
        setIconBack(R.drawable.ic_close);
        setTitle(getString(R.string.register_new_member));

        mBtnSignUp = (Button)findViewById(R.id.btn_sign_up);
        mBtnSignUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String username = mEdtUsername.getText().toString();
                String email = mEdtEmail.getText().toString();
                if(username.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_username), false);
                    return;
                }
                if(email.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_email), false);
                    return;
                }
                if(!CommonUtils.isEmailValid(email)){
                    new DialogUtiils().showDialog(mContext, getString(R.string.email_invalid), false);
                    return;
                }
                String password = mEdtPassword.getText().toString();
                String confirmPass = mEdtPasswordConfirm.getText().toString();

                if(password.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_password), false);
                    return;
                }
                if(password.length() < 6){
                    new DialogUtiils().showDialog(mContext, getString(R.string.invalid_password), false);
                    return;
                }
                if (!password.equalsIgnoreCase(confirmPass)) {
                    new DialogUtiils().showDialog(mContext, getString(R.string.password_not_match), false);
                    return;
                }

                new UserProfileAPIHelper().signUp(mContext, username, email, password, mHanlderSignUp);
            }
        });

        mTvBackToLogin = (TextView)findViewById(R.id.tv_back_to_login);
        mTvBackToLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                setResult(Activity.RESULT_CANCELED);
                finish();
            }
        });

        mEdtEmail = (EditText)findViewById(R.id.edt_email);
        mEdtUsername = (EditText)findViewById(R.id.edt_username);
        mEdtPassword = (EditText)findViewById(R.id.edt_password);
        mEdtPasswordConfirm = (EditText)findViewById(R.id.edt_password_confirm);
    }

    private Handler mHanlderSignUp = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon)msg.obj;
                    String message = res.message;
                    if(res.code == APIConstants.REQUEST_OK) {
                        new DialogUtiils().showDialog(mContext, message, mDialogConfirm);
                    } else {
                        new DialogUtiils().showDialog(mContext, message, false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
                default:
                    break;
            }

        }
    };

    @Override
    public void onDialogButtonConfirm() {
        Intent data = new Intent();
        data.putExtra(Constants.EXTRA_USER_NAME, mEdtUsername.getText().toString());
        setResult(Activity.RESULT_OK, data);
        finish();
    }
}
