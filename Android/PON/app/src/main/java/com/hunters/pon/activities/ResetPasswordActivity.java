package com.hunters.pon.activities;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.hunters.pon.R;
import com.hunters.pon.customs.CustomEditText;

public class ResetPasswordActivity extends BaseActivity {

    private CustomEditText mEdtEmailRegistered;
    private Button mBtnSend;

    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_reset_password);
        super.onCreate(savedInstanceState);
        initLayout();
    }

    private void initLayout()
    {
        setTitle(getString(R.string.reset_password));

        mEdtEmailRegistered = (CustomEditText)findViewById(R.id.edt_email);
        mBtnSend = (Button)findViewById(R.id.btn_send);
        mBtnSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });

    }
}