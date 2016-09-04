package com.hunters1984.pon.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.hunters1984.pon.R;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
