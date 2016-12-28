package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.qrcode.QRCodeUtils;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.hunters.pon.utils.ImageUtils;
import com.hunters.pon.utils.PermissionUtils;
import com.squareup.picasso.Picasso;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.io.File;

import br.com.dina.oauth.instagram.InstagramApp;
import jp.line.android.sdk.LineSdkContextManager;
import jp.line.android.sdk.login.LineAuthManager;
import jp.line.android.sdk.login.LineLoginFuture;
import jp.line.android.sdk.login.LineLoginFutureListener;

public class ShareCouponActivity extends BaseActivity implements ActivityCompat.OnRequestPermissionsResultCallback {

    private ImageView mIvQRCode;
    private View mViewSNSShare;
    private Context mContext;
    private Button mBtnSNSShare, mBtnQRCodeShare;
    private CallbackManager mCallbackManager;
    private ShareDialog mShareDialog;
    private View mShareFacebook, mShareInstagram, mShareTwitter, mShareLine;
    private CouponModel mCoupon;

    private CallbackManager mFacebookCallbackManager;
    private LoginButton mFacebookSignInButton;
    private InstagramApp mApp;
    private TwitterLoginButton mTwitterSignInButton;

    private enum SignInType {
        Facebook,
        Twitter,
        Instagram,
        Line
    }

    private SignInType mSignInType;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_share_coupon);
        mContext = this;
        super.onCreate(savedInstanceState);
        mCoupon = (CouponModel) getIntent().getSerializableExtra(Constants.EXTRA_DATA);
        mFacebookCallbackManager = CallbackManager.Factory.create();

        initLayout();
        if(mCoupon != null) {
            if(mCoupon.getmCode() != null) {
                new QRCodeUtils().genQRCode(mContext, mCoupon.getmCode(), mIvQRCode);
//                mBtnQRCodeShare.setVisibility(View.VISIBLE);
            }
//            else {
//                mBtnQRCodeShare.setVisibility(View.GONE);
//            }
        }

        initFacebook();
        initTwitter();
        initInstagram();
        initLine();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.SHARE_COUPON_SCREEN);
    }

    private void initLayout()
    {
        mIvQRCode = (ImageView)findViewById(R.id.iv_qr_code);
        mBtnSNSShare = (Button)findViewById(R.id.btn_sns);
        mBtnQRCodeShare = (Button)findViewById(R.id.btn_qr_code);
        mBtnQRCodeShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showQRCodeShare();
            }
        });
        mBtnSNSShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
               showSNSShare();
            }
        });
        mViewSNSShare = findViewById(R.id.rl_sns_share);
        mShareFacebook = (findViewById(R.id.rl_share_facebook));
        mShareInstagram = findViewById(R.id.rl_share_instagram);
        mShareTwitter = findViewById(R.id.rl_share_twitter);
        mShareLine = findViewById(R.id.rl_share_line);

        mShareFacebook.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GoogleAnalyticUtils.getInstance(mContext).logEventShareCoupon((PonApplication)((Activity)mContext).getApplication());
                mSignInType = SignInType.Facebook;
                loginFacebook();
                //shareFacebook();
            }
        });

        mShareTwitter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GoogleAnalyticUtils.getInstance(mContext).logEventShareCoupon((PonApplication)((Activity)mContext).getApplication());
                mSignInType = SignInType.Twitter;
                loginTwitter();
//                shareTwitter();
            }
        });

        mShareInstagram.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GoogleAnalyticUtils.getInstance(mContext).logEventShareCoupon((PonApplication)((Activity)mContext).getApplication());
                mSignInType = SignInType.Instagram;
                loginInstagram();
//                shareInstagram();
            }
        });

        mShareLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                GoogleAnalyticUtils.getInstance(mContext).logEventShareCoupon((PonApplication)((Activity)mContext).getApplication());
                mSignInType = SignInType.Line;
                loginLine();
//                shareLine();
            }
        });
        showSNSShare();
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mCallbackManager.onActivityResult(requestCode, resultCode, data);

        mFacebookCallbackManager.onActivityResult(requestCode, resultCode, data);

        if(TwitterAuthConfig.DEFAULT_AUTH_REQUEST_CODE == requestCode) {
            mTwitterSignInButton.onActivityResult(requestCode, resultCode, data);
        }
    }

    private void showSNSShare()
    {
        mIvQRCode.setVisibility(View.GONE);
        mViewSNSShare.setVisibility(View.VISIBLE);
        mBtnQRCodeShare.setBackgroundColor(ContextCompat.getColor(mContext, R.color.transparent));
        mBtnSNSShare.setBackgroundColor(ContextCompat.getColor(mContext, R.color.white));
    }

    private void showQRCodeShare()
    {
        mIvQRCode.setVisibility(View.VISIBLE);
        mViewSNSShare.setVisibility(View.GONE);
        mBtnQRCodeShare.setBackgroundColor(ContextCompat.getColor(mContext, R.color.white));
        mBtnSNSShare.setBackgroundColor(ContextCompat.getColor(mContext, R.color.transparent));

        if(mCoupon.getmCode() == null) {
            new DialogUtiils().showDialog(mContext, getString(R.string.cannot_use_coupon), false);
        }
    }

    private void initFacebook()
    {
        mFacebookSignInButton = (LoginButton)findViewById(R.id.facebook_sign_in_button);
        mFacebookSignInButton.setReadPermissions("email", "user_posts", "user_photos");
        mFacebookSignInButton.registerCallback(mFacebookCallbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(final LoginResult loginResult) {
                        String token = loginResult.getAccessToken().getToken();
                        new UserProfileAPIHelper().signInShareFacebook(mContext, token, mHanlderSignIn);
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
        mCallbackManager = CallbackManager.Factory.create();
        //End of Facebook
    }

    private void loginFacebook()
    {
        LoginManager.getInstance().logOut();
        mFacebookSignInButton.performClick();
    }

    private void initTwitter()
    {
        mTwitterSignInButton = (TwitterLoginButton) findViewById(R.id.twitter_sign_in_button);
        mTwitterSignInButton.setCallback(new Callback<TwitterSession>() {
            @Override
            public void success(Result<TwitterSession> result) {
                // The TwitterSession is also available through:
                // Twitter.getInstance().core.getSessionManager().getActiveSession()
                TwitterSession session = result.data;
                String accessToken = session.getAuthToken().token;
                String secrectToken = session.getAuthToken().secret;

                new UserProfileAPIHelper().signInShareTwitter(mContext, accessToken, secrectToken, mHanlderSignIn);
            }
            @Override
            public void failure(TwitterException exception) {
                new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                exception.printStackTrace();
            }
        });
    }

    private void loginTwitter()
    {
        mTwitterSignInButton.performClick();
    }

    private void initInstagram()
    {
        mApp = new InstagramApp(this, Constants.INSTAGRAM_CLIENT_ID,
                Constants.INSTAGRAM_CLIENT_SECRET, Constants.INSTAGRAM_CALLBACK_URL);
        mApp.setListener(listener);
    }

    private InstagramApp.OAuthAuthenticationListener listener = new InstagramApp.OAuthAuthenticationListener() {

        @Override
        public void onSuccess() {
            String token = mApp.getmAccessToken();
            new UserProfileAPIHelper().signInShareInstagram(mContext, token, mHanlderSignIn);

        }

        @Override
        public void onFail(String error) {

        }
    };

    private void loginInstagram()
    {
        if(mApp != null) {
            mApp.resetAccessToken();
            mApp.authorize();
        }
    }

    private void initLine()
    {
        LineSdkContextManager.initialize(this);
    }

    private void loginLine()
    {
        LineAuthManager authManager = LineSdkContextManager.getSdkContext().getAuthManager();
        authManager.logout();
        authManager.login(this).addFutureListener(
                new LineLoginFutureListener() {
                    @Override
                    public void loginComplete(LineLoginFuture future) {
                        switch (future.getProgress()) {
                            case SUCCESS:
                                if(future != null) {
                                    String token = future.getAccessToken().accessToken;
                                    shareLine();
//                                    new UserProfileAPIHelper().signInShareLine(mContext, token, mHanlderSignIn);
                                }
                                break;
                            case CANCELED:

                                break;
                            default:

                                break;
                        }
                    }
                });
    }

    private Handler mHanlderSignIn = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon user = (ResponseCommon) msg.obj;
                    if (user.code == APIConstants.REQUEST_OK && user.httpCode == APIConstants.HTTP_OK) {
                        if(mSignInType == SignInType.Facebook) {
                            shareFacebook();
                        } else if (mSignInType == SignInType.Twitter) {
                            shareTwitter();
                        } else if (mSignInType == SignInType.Instagram){
                            shareInstagram();
                        } else if (mSignInType == SignInType.Line){
                            shareLine();
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

    private void shareFacebook()
    {
        showProgressDialog(mContext);

        mShareDialog = new ShareDialog(this);

        if (ShareDialog.canShow(ShareLinkContent.class) && mCoupon != null) {
            ShareLinkContent linkContent = new ShareLinkContent.Builder()
                        .setContentTitle(mCoupon.getmTwitterLinkShare())
//                        .setContentDescription(mCoupon.getmTwitterLinkShare())
                        .setContentUrl(Uri.parse(mCoupon.getmFacebookLinkShare()))
                        .build();
            mShareDialog.show(linkContent);
        }
        closeDialog();
    }

    private void shareTwitter() {
        if (!PermissionUtils.newInstance().isGrantStoragePermission(this)) {
            PermissionUtils.newInstance().requestStoragePermission(this);
        } else {
            proccessDownloadAndCachePhoto();
        }
    }

    private void shareInstagram()
    {
        if (CommonUtils.isPackageInstalled(mContext, Constants.PACKAGE_INSTAGRAM)){
            if (!PermissionUtils.newInstance().isGrantStoragePermission(this)) {
                PermissionUtils.newInstance().requestStoragePermission(this);
            } else {
                proccessDownloadAndCachePhoto();
            }
        } else {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse("market://details?id=" + Constants.PACKAGE_INSTAGRAM));
                startActivity(intent);
            } catch(Exception e){
                new DialogUtiils().showDialog(mContext, getString(R.string.instagram_install), false);
            }
        }

    }

    private void proccessDownloadAndCachePhoto()
    {
        showProgressDialog(mContext);
        Picasso.with(this).load(mCoupon.getmInstagramLinkShare())
                .into(ImageUtils.picassoImageTarget(getApplicationContext(), "share_coupon.jpg", mHanlderCompletionSaveImage));
    }

    private void shareLine()
    {
        showProgressDialog(mContext);
        if(CommonUtils.isPackageInstalled(mContext, Constants.PACKAGE_LINE)) {
            Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_TEXT, mCoupon.getmLineLinkShare());
            shareIntent.setPackage(Constants.PACKAGE_LINE);
            startActivity(shareIntent);
        } else {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse("market://details?id=" + Constants.PACKAGE_LINE));
                startActivity(intent);
            }catch (Exception e) {
                new DialogUtiils().showDialog(mContext, getString(R.string.line_install), false);
            }
        }
        closeDialog();
    }

    private Handler mHanlderCompletionSaveImage = new Handler(){
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what){
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    File cacheFile = new File(CommonUtils.getFileCache("share_coupon.jpg"));
                    Uri file = Uri.fromFile(cacheFile);

                    if (mSignInType == SignInType.Instagram) {
                        Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
                        shareIntent.setType("image/*");
                        shareIntent.putExtra(Intent.EXTRA_STREAM, file);
                        shareIntent.setPackage(Constants.PACKAGE_INSTAGRAM);
                        startActivity(shareIntent);
                    } else if (mSignInType == SignInType.Twitter) {
                        TweetComposer.Builder builder = new TweetComposer.Builder(mContext)
                                .image(file)
                                .text(mCoupon.getmTwitterLinkShare());
                        builder.show();
                        closeDialog();
                    }

                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
            closeDialog();
        }
    };

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode == PermissionUtils.REQUEST_WRITE_EXTERNAL_STORAGE) {
            if(grantResults[0] == PackageManager.PERMISSION_DENIED ) {
                new DialogUtiils().showDialog(this, getString(R.string.storage_denie), false);
            } else {
                proccessDownloadAndCachePhoto();
            }
        }
    }
}
