package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;

import com.crashlytics.android.Crashlytics;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import io.fabric.sdk.android.Fabric;

public class SplashActivity extends AppCompatActivity {

    // Note: Your consumer key and secret should be obfuscated in your source code before shipping.
    private static final String TWITTER_KEY = "002neLhPbyLMt6rBP68wVVstN";//"lR5KcVjRjsMB0m5wBhzlkt7xm";
    private static final String TWITTER_SECRET = "u2Cp1LFDin1zeQXxqXdgQEddZP06wsEPMxotStnThe7OsBVK43";//"P1mIpYeWDKWIqTAJ8erjZwBka9fbvFCjzG1O3AQPF77kCCCFob";

    private ExtraDataModel mExtraData;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);
        TwitterAuthConfig authConfig = new TwitterAuthConfig(TWITTER_KEY, TWITTER_SECRET);
        Fabric.with(this, new Crashlytics(), new Twitter(authConfig), new TweetComposer());
        setContentView(R.layout.activity_splash);

        mExtraData = (ExtraDataModel)getIntent().getSerializableExtra(Constants.EXTRA_DATA);
        initLayout();
        if(mExtraData == null){
            String token = CommonUtils.getToken(this);

            if(!token.equalsIgnoreCase("")) {
                new UserProfileAPIHelper().checkValidToken(this, token, mHanlderCheckValidToken);
            }
        }

        GoogleAnalyticUtils.getInstance(this).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.SPLASH_SCREEN);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL || requestCode == Constants.REQUEST_CODE_ADD_FAVOURITE
                || requestCode == Constants.REQUEST_CODE_FOLLOW_SHOP || requestCode == Constants.REQUEST_CODE_USE_COUPON) {
            if (resultCode == Activity.RESULT_OK) {
                Intent intent = new Intent();
                intent.putExtra(Constants.EXTRA_DATA, mExtraData);
                setResult(Activity.RESULT_OK, intent);
                finish();
            }
        }
    }

    private void initLayout()
    {
        Button btnLogin = (Button)findViewById(R.id.btn_login);
        Button btnSkip = (Button)findViewById(R.id.btn_skip);

        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iLoginScreen = new Intent(SplashActivity.this, SplashSelectLoginActivity.class);
                iLoginScreen.putExtra(Constants.EXTRA_DATA, mExtraData);
                if(mExtraData != null) {
                    if(mExtraData.getmTitle().equalsIgnoreCase(Constants.EXTRA_ADD_FAVOURITE)){
                        startActivityForResult(iLoginScreen, Constants.REQUEST_CODE_ADD_FAVOURITE);
                    } else if(mExtraData.getmTitle().equalsIgnoreCase(Constants.EXTRA_FOLLOW_SHOP)){
                        startActivityForResult(iLoginScreen, Constants.REQUEST_CODE_FOLLOW_SHOP);
                    } else if(mExtraData.getmTitle().equalsIgnoreCase(Constants.EXTRA_VIEW_COUPON_DETAIL)) {
                        startActivityForResult(iLoginScreen, Constants.REQUEST_CODE_COUPON_DETAIL);
                    } else if(mExtraData.getmTitle().equalsIgnoreCase(Constants.EXTRA_USE_COUPON)){
                        startActivityForResult(iLoginScreen, Constants.REQUEST_CODE_USE_COUPON);
                    }
                } else {
                    startActivity(iLoginScreen);
                }

            }
        });

        btnSkip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mExtraData == null) {
                    CommonUtils.saveToken(SplashActivity.this, "");
                    LoginManager.getInstance().logOut();
                    Intent iMainScreen = new Intent(SplashActivity.this, MainTopActivity.class);
                    iMainScreen.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(iMainScreen);
                } else {
                    setResult(Activity.RESULT_CANCELED);
                }
                finish();
            }
        });
    }

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if (res.httpCode == APIConstants.HTTP_OK && res.code == APIConstants.REQUEST_OK) {
                        Intent iMainScreen = new Intent(SplashActivity.this, MainTopActivity.class);
                        iMainScreen.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                        startActivity(iMainScreen);
//                        finish();
                    } else if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(SplashActivity.this, "");
                        LoginManager.getInstance().logOut();
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    LoginManager.getInstance().logOut();
                    new DialogUtiils().showDialog(SplashActivity.this, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
