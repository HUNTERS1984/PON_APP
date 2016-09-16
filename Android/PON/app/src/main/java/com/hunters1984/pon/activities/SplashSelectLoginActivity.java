package com.hunters1984.pon.activities;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.RelativeLayout;

import com.facebook.CallbackManager;
import com.facebook.FacebookSdk;
import com.facebook.login.widget.LoginButton;
import com.hunters1984.pon.R;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterCore;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;

import io.fabric.sdk.android.Fabric;

public class SplashSelectLoginActivity extends BaseActivity {

    // Note: Your consumer key and secret should be obfuscated in your source code before shipping.
    private static final String TWITTER_KEY = "lR5KcVjRjsMB0m5wBhzlkt7xm";
    private static final String TWITTER_SECRET = "P1mIpYeWDKWIqTAJ8erjZwBka9fbvFCjzG1O3AQPF77kCCCFob";

    private CallbackManager mFacebookCallbackManager;
    private LoginButton mFacebookSignInButton;

    private TwitterLoginButton loginButton;

    private RelativeLayout mRlFacebookLogin, mRlTwitterLogin, mRlEmailLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FacebookSdk.sdkInitialize(getApplicationContext());
        mFacebookCallbackManager = CallbackManager.Factory.create();

        TwitterAuthConfig authConfig = new TwitterAuthConfig(TWITTER_KEY,
                TWITTER_SECRET);
        Fabric.with(this, new TwitterCore(authConfig));

        setContentView(R.layout.activity_splash_select_login);

        initLayout();

//        mFacebookSignInButton = (LoginButton)findViewById(R.id.facebook_sign_in_button);
//        mFacebookSignInButton.registerCallback(mFacebookCallbackManager,
//                new FacebookCallback<LoginResult>() {
//                    @Override
//                    public void onSuccess(final LoginResult loginResult) {
//
//                    }
//
//                    @Override
//                    public void onCancel() {
//
//                    }
//
//                    @Override
//                    public void onError(FacebookException error) {
//                    }
//                }
//        );


//        loginButton = (TwitterLoginButton) findViewById(R.id.twitter_login_button);
//        loginButton.setCallback(new Callback<TwitterSession>() {
//            @Override
//            public void success(Result<TwitterSession> result) {
//                // The TwitterSession is also available through:
//                // Twitter.getInstance().core.getSessionManager().getActiveSession()
//                TwitterSession session = result.data;
//                // TODO: Remove toast and use the TwitterSession's userID
//                // with your app's user model
//                String msg = "@" + session.getUserName() + " logged in! (#" + session.getUserId() + ")";
//                Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_LONG).show();
//            }
//            @Override
//            public void failure(TwitterException exception) {
//
//            }
//        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // Make sure that the loginButton hears the result from any
        // Activity that it triggered.
        mFacebookCallbackManager.onActivityResult(requestCode, resultCode, data);

        if(TwitterAuthConfig.DEFAULT_AUTH_REQUEST_CODE == requestCode) {
            loginButton.onActivityResult(requestCode, resultCode, data);
        }
    }

    private void initLayout()
    {
        mRlFacebookLogin = (RelativeLayout)findViewById(R.id.rl_facebook_login);
        mRlTwitterLogin = (RelativeLayout)findViewById(R.id.rl_twitter_login);
        mRlEmailLogin = (RelativeLayout)findViewById(R.id.rl_email_login);

        mRlEmailLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(SplashSelectLoginActivity.this, SignInEmailActivity.class, true);
            }
        });
    }
}
