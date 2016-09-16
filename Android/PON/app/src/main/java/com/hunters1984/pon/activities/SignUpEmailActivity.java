package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.hunters1984.pon.R;

public class SignUpEmailActivity extends BaseActivity {

    private Button mBtnSignUp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_sign_up_email);
        super.onCreate(savedInstanceState);

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

            }
        });
    }
}
