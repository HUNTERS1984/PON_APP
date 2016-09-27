package com.hunters1984.pon.activities;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.api.UserProfileAPIHelper;
import com.hunters1984.pon.utils.DialogUtiils;

public class SignUpEmailActivity extends BaseActivity {

    private Button mBtnSignUp;
    private TextView mTvBackToLogin;
    private EditText mEdtUsername, mEdtEmail, mEdtPassword, mEdtPasswordConfirm;
    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_sign_up_email);
        super.onCreate(savedInstanceState);
        mContext = this;
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
                String password = mEdtPassword.getText().toString();
                String confirmPass = mEdtPasswordConfirm.getText().toString();

                if (!password.equalsIgnoreCase(confirmPass)) {
                    new DialogUtiils().showDialog(mContext, getString(R.string.password_not_match));
                    return;
                }

                String username = mEdtUsername.getText().toString();
                String email = mEdtEmail.getText().toString();
                new UserProfileAPIHelper().signUp(mContext, username, email, password, mHanlderSignUp);
            }
        });

        mTvBackToLogin = (TextView)findViewById(R.id.tv_back_to_login);
        mTvBackToLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
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
            new DialogUtiils().showDialog(mContext, msg.obj.toString());
        }
    };
}
