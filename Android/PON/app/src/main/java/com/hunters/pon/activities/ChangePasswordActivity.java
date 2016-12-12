package com.hunters.pon.activities;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.KeyboardUtils;

public class ChangePasswordActivity extends BaseActivity {

    private EditText mEdtCurrentPass, mEdtNewPass, mEdtNewPassConfirmation;
    private Context mContext;
    private Button mBtnSave;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_change_password);
        super.onCreate(savedInstanceState);

        initLayout();
    }


    private void initLayout()
    {

        setTitle(getString(R.string.change_password));

        mEdtCurrentPass = (EditText)findViewById(R.id.edt_current_password);
        mEdtNewPass = (EditText)findViewById(R.id.edt_new_password);
        mEdtNewPassConfirmation = (EditText)findViewById(R.id.edt_new_password_confirmation);

        mBtnSave = (Button)findViewById(R.id.btn_save);
        mBtnSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String oldPass = mEdtCurrentPass.getText().toString();
                String newPass = mEdtNewPass.getText().toString();
                String newPassConfirm = mEdtNewPassConfirmation.getText().toString();

                if(oldPass.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_password), false);
                    return;
                }

                if(newPass.equalsIgnoreCase("")){
                    new DialogUtiils().showDialog(mContext, getString(R.string.input_password), false);
                    return;
                }

                if(!newPass.equalsIgnoreCase(newPassConfirm)){
                    new DialogUtiils().showDialog(mContext, getString(R.string.password_not_match), false);
                    return;
                }

                new UserProfileAPIHelper().changePassword(mContext, oldPass, newPass, newPassConfirm, mHanlderChangePass);

            }
        });
    }

    private Handler mHanlderChangePass = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            new KeyboardUtils().hideKeyboard(mContext);
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(mContext, "");
                        checkToUpdateButtonLogin();
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
                    } else if (res.httpCode == APIConstants.HTTP_OK && res.code == APIConstants.REQUEST_OK) {
                        new DialogUtiils().showDialog(mContext, res.message, true);
                    } else {
                        new DialogUtiils().showDialog(mContext, res.message, false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
