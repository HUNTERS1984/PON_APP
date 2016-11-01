package com.hunters.ponstaff.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.hunters.ponstaff.R;
import com.hunters.ponstaff.api.APIConstants;
import com.hunters.ponstaff.api.ResponseUserData;
import com.hunters.ponstaff.api.UserProfileAPIHelper;
import com.hunters.ponstaff.utils.CommonUtils;
import com.hunters.ponstaff.utils.DialogUtils;
import com.hunters.ponstaff.utils.KeyboardUtils;

public class LoginActivity extends AppCompatActivity {

    private Context mContext;

    private EditText mEdtUsername, mEdtPassword;
    private Button mBtnLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        mContext = this;

        initLayout();
    }

    private void initLayout()
    {
        mEdtUsername = (EditText)findViewById(R.id.edt_username);
        mEdtPassword = (EditText)findViewById(R.id.edt_password);

        //Init username and password
        mEdtUsername.setText("store_0@pon.dev");
        mEdtPassword.setText("admin");

        mBtnLogin = (Button)findViewById(R.id.btn_login);
        mBtnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new KeyboardUtils().hideKeyboard(mContext);
                String username = mEdtUsername.getText().toString();
                String password = mEdtPassword.getText().toString();
                new UserProfileAPIHelper().signIn(mContext, username, password, mHanlderSignIn);
            }
        });

    }

    private Handler mHanlderSignIn = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseUserData user = (ResponseUserData) msg.obj;
                    if (user.code == APIConstants.REQUEST_OK && user.httpCode == APIConstants.HTTP_OK) {
                        CommonUtils.saveToken(mContext, user.data.token);

                        Intent iMainScreen = new Intent(LoginActivity.this, MainActivity.class);
                        iMainScreen.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        startActivity(iMainScreen);

                        finish();
                    } else {
                        new DialogUtils().showDialog(mContext, user.message, false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
