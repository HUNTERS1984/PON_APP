package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseUserData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;

public class SplashSelectLoginActivity extends BaseActivity {

    private CallbackManager mFacebookCallbackManager;
    private LoginButton mFacebookSignInButton;

    private TwitterLoginButton mTwitterSignInButton;

    private RelativeLayout mRlFacebookLogin, mRlTwitterLogin, mRlEmailLogin;
    private ExtraDataModel mDataExtra;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mContext = this;
        mFacebookCallbackManager = CallbackManager.Factory.create();

        setContentView(R.layout.activity_splash_select_login);

        mDataExtra = (ExtraDataModel)getIntent().getSerializableExtra(Constants.EXTRA_DATA);

        initLayout();

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // Make sure that the loginButton hears the result from any
        // Activity that it triggered.
        mFacebookCallbackManager.onActivityResult(requestCode, resultCode, data);

        if(TwitterAuthConfig.DEFAULT_AUTH_REQUEST_CODE == requestCode) {
            mTwitterSignInButton.onActivityResult(requestCode, resultCode, data);
        }

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL || requestCode == Constants.REQUEST_CODE_ADD_FAVOURITE
                || requestCode == Constants.REQUEST_CODE_FOLLOW_SHOP || requestCode == Constants.REQUEST_CODE_USE_COUPON ) {
            if (resultCode == Activity.RESULT_OK) {
                Intent intent = new Intent();
                intent.putExtra(Constants.EXTRA_DATA, mDataExtra);
                setResult(Activity.RESULT_OK, intent);
                finish();
            }
        }
    }

    private void initLayout()
    {
        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });

        mRlFacebookLogin = (RelativeLayout)findViewById(R.id.rl_facebook_login);
        mRlTwitterLogin = (RelativeLayout)findViewById(R.id.rl_twitter_login);
        mRlEmailLogin = (RelativeLayout)findViewById(R.id.rl_email_login);

        mRlEmailLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iEmailLogin = new Intent(SplashSelectLoginActivity.this, SignInEmailActivity.class);
                iEmailLogin.putExtra(Constants.EXTRA_DATA, mDataExtra);
                if(mDataExtra == null) {
                    startActivity(iEmailLogin);
                } else {
                    if(mDataExtra.getmTitle().equalsIgnoreCase(Constants.EXTRA_ADD_FAVOURITE)){
                        startActivityForResult(iEmailLogin, Constants.REQUEST_CODE_ADD_FAVOURITE);
                    } else if(mDataExtra.getmTitle().equalsIgnoreCase(Constants.EXTRA_FOLLOW_SHOP)){
                        startActivityForResult(iEmailLogin, Constants.REQUEST_CODE_FOLLOW_SHOP);
                    } else if(mDataExtra.getmTitle().equalsIgnoreCase(Constants.EXTRA_VIEW_COUPON_DETAIL)){
                        startActivityForResult(iEmailLogin, Constants.REQUEST_CODE_COUPON_DETAIL);
                    } else if(mDataExtra.getmTitle().equalsIgnoreCase(Constants.EXTRA_USE_COUPON)){
                        startActivityForResult(iEmailLogin, Constants.REQUEST_CODE_USE_COUPON);
                    }
                }
            }
        });

        //Facebook
        mRlFacebookLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mFacebookSignInButton.performClick();
            }
        });

        mFacebookSignInButton = (LoginButton)findViewById(R.id.facebook_sign_in_button);
        mFacebookSignInButton.setReadPermissions("email");
        mFacebookSignInButton.registerCallback(mFacebookCallbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(final LoginResult loginResult) {
                        String token = loginResult.getAccessToken().getToken();
                        new UserProfileAPIHelper().signInFacebook(mContext, token, mHanlderSignIn);
                    }

                    @Override
                    public void onCancel() {

                    }

                    @Override
                    public void onError(FacebookException error) {
                        new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    }
                }
        );
        //End of Facebook

        //Twitter
        mRlTwitterLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mTwitterSignInButton.performClick();
            }
        });

        mTwitterSignInButton = (TwitterLoginButton) findViewById(R.id.twitter_sign_in_button);
        mTwitterSignInButton.setCallback(new Callback<TwitterSession>() {
            @Override
            public void success(Result<TwitterSession> result) {
                // The TwitterSession is also available through:
                // Twitter.getInstance().core.getSessionManager().getActiveSession()
                TwitterSession session = result.data;
                String accessToken = session.getAuthToken().token;
                String secrectToken = session.getAuthToken().secret;

                new UserProfileAPIHelper().signInTwitter(mContext, accessToken, secrectToken, mHanlderSignIn);
            }
            @Override
            public void failure(TwitterException exception) {
                new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                exception.printStackTrace();
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
                        if(user.data != null) {
                            CommonUtils.saveToken(mContext, user.data.token);
                            if(mDataExtra == null) {
                                Intent iMainScreen = new Intent(SplashSelectLoginActivity.this, MainTopActivity.class);
                                iMainScreen.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                                startActivity(iMainScreen);
                            } else {
                                Intent intent = new Intent();
                                intent.putExtra(Constants.EXTRA_DATA, mDataExtra);
                                setResult(Activity.RESULT_OK, intent);
                                finish();
                            }
                        } else {
                            new DialogUtiils().showDialog(mContext, user.message, false);
                        }
                    } else {
                        new DialogUtiils().showDialog(mContext, user.message, false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
