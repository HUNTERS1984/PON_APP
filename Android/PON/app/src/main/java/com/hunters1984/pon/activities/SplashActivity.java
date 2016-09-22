package com.hunters1984.pon.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.crashlytics.android.Crashlytics;
import com.hunters1984.pon.R;

import io.fabric.sdk.android.Fabric;

public class SplashActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_splash);

        initLayout();
    }

    private void initLayout()
    {
        Button btnLogin = (Button)findViewById(R.id.btn_login);
        Button btnSkip = (Button)findViewById(R.id.btn_skip);

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iLoginScreen = new Intent(SplashActivity.this, SplashSelectLoginActivity.class);
                startActivity(iLoginScreen);
            }
        });

        btnSkip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iMainScreen = new Intent(SplashActivity.this, MainActivity.class);
                iMainScreen.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(iMainScreen);
                finish();
            }
        });
    }
}
