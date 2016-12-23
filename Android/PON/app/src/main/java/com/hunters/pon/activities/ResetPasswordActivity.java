package com.hunters.pon.activities;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;

import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.customs.CustomEditText;
import com.hunters.pon.protocols.OnDialogButtonConfirm;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;

public class ResetPasswordActivity extends BaseActivity implements OnDialogButtonConfirm {

    private CustomEditText mEdtEmailRegistered;
    private Button mBtnSend;

    private Context mContext;
    private OnDialogButtonConfirm mDialogConfirm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDialogConfirm = this;
        setContentView(R.layout.activity_reset_password);
        super.onCreate(savedInstanceState);
        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.FORGOT_PASS_SCREEN);
    }

    private void initLayout()
    {
        setTitle(getString(R.string.reset_password));

        mEdtEmailRegistered = (CustomEditText)findViewById(R.id.edt_email);
        mBtnSend = (Button)findViewById(R.id.btn_send);
        mBtnSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String email = mEdtEmailRegistered.getText().toString();
                if(email.equalsIgnoreCase("")){
                    mEdtEmailRegistered.requestFocus();
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_email), false);
                    return;
                }
                if(!CommonUtils.isEmailValid(email)){
                    mEdtEmailRegistered.requestFocus();
                    new DialogUtiils().showDialog(mContext, getString(R.string.email_invalid), false);
                    return;
                }
                new UserProfileAPIHelper().forgotPassword(mContext, email, mHanlderForgotPass);
            }
        });
    }

    private Handler mHanlderForgotPass = new Handler(){
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
        finish();
    }
}
