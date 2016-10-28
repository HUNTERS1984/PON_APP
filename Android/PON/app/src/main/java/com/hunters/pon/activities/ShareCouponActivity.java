package com.hunters.pon.activities;

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
import com.facebook.FacebookSdk;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.qrcode.QRCodeUtils;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.ImageUtils;
import com.hunters.pon.utils.PermissionUtils;
import com.squareup.picasso.Picasso;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class ShareCouponActivity extends BaseActivity implements ActivityCompat.OnRequestPermissionsResultCallback {

    private ImageView mIvQRCode;
    private View mViewSNSShare;
    private Context mContext;
    private Button mBtnSNSShare, mBtnQRCodeShare;
    private CallbackManager mCallbackManager;
    private ShareDialog mShareDialog;
    private View mShareFacebook, mShareInstagram, mShareTwitter, mShareLine;
    private CouponModel mCoupon;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_share_coupon);
        mContext = this;
        super.onCreate(savedInstanceState);
        mCoupon = (CouponModel) getIntent().getSerializableExtra(Constants.EXTRA_DATA);

        initLayout();
        if(mCoupon != null) {
            new QRCodeUtils().genQRCode(mContext, mCoupon.getmCode(), mIvQRCode);
        }
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
                shareFacebook();
            }
        });

        mShareTwitter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                shareTwitter();
            }
        });

        mShareInstagram.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                shareInstagram();
            }
        });

        mShareLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                shareLine();
            }
        });
        showSNSShare();
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mCallbackManager.onActivityResult(requestCode, resultCode, data);
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
    }

    private void shareFacebook()
    {
        showProgressDialog(mContext);
        FacebookSdk.sdkInitialize(getApplicationContext());
        mCallbackManager = CallbackManager.Factory.create();
        mShareDialog = new ShareDialog(this);

        if (ShareDialog.canShow(ShareLinkContent.class) && mCoupon != null) {
            ShareLinkContent linkContent = new ShareLinkContent.Builder()
    //                    .setContentTitle(mCoupon.getmTitle())
    //                    .setContentDescription(
    //                           mCoupon.getmDescription())
                        .setContentUrl(Uri.parse(mCoupon.getmImageUrl()))
                        .build();
            mShareDialog.show(linkContent);
        }
        closeDialog();
    }

    private void shareTwitter() {
        showProgressDialog(mContext);
        TweetComposer.Builder builder = null;
        try {
            builder = new TweetComposer.Builder(this)
                    .url(new URL(mCoupon.getmImageUrl()));
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        builder.show();
        closeDialog();
    }

    private void shareInstagram()
    {
        if (CommonUtils.isPackageInstalled(mContext, Constants.PACKAGE_INSTAGRAM)){
            if (!PermissionUtils.newInstance().isGrantStoragePermission(this)) {
                PermissionUtils.newInstance().requestStoragePermission(this);
            } else {
                proccessShareInstagram();
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

    private void proccessShareInstagram()
    {
        showProgressDialog(mContext);
        Picasso.with(this).load(mCoupon.getmImageUrl())
//                .resize(CommonUtils.dpToPx(mContext, 120), CommonUtils.dpToPx(mContext, 120))
                .into(ImageUtils.picassoImageTarget(getApplicationContext(), "share_coupon.jpg", mHanlderCompletionSaveImage));
    }

    private void shareLine()
    {
        showProgressDialog(mContext);
        if(CommonUtils.isPackageInstalled(mContext, Constants.PACKAGE_LINE)) {
            Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_TEXT, mCoupon.getmImageUrl());
//            shareIntent.putExtra(Intent.EXTRA_TITLE, mCoupon.getmTitle());
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

                    Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
                    shareIntent.setType("image/*");
                    shareIntent.putExtra(Intent.EXTRA_STREAM, file);
                    shareIntent.setPackage(Constants.PACKAGE_INSTAGRAM);
                    startActivity(shareIntent);

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
                proccessShareInstagram();
            }
        }
    }
}
