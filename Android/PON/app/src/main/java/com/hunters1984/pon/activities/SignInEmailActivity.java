package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.hunters1984.pon.R;

public class SignInEmailActivity extends BaseActivity {

    private Button mBtnLogin;

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

        mBtnLogin = (Button) findViewById(R.id.btn_login);
        mBtnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(SignInEmailActivity.this, SignUpEmailActivity.class, false);
            }
        });
    }
}
