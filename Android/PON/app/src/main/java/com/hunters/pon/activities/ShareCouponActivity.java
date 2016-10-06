package com.hunters.pon.activities;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.facebook.CallbackManager;
import com.facebook.FacebookSdk;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.hunters.pon.R;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.qrcode.QRCodeUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.ImageUtils;
import com.squareup.picasso.Picasso;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class ShareCouponActivity extends BaseActivity {

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
        FacebookSdk.sdkInitialize(getApplicationContext());
        mCallbackManager = CallbackManager.Factory.create();
        mShareDialog = new ShareDialog(this);

        if (ShareDialog.canShow(ShareLinkContent.class) && mCoupon != null) {
            ShareLinkContent linkContent = new ShareLinkContent.Builder()
                    .setContentTitle(mCoupon.getmTitle())
                    .setContentDescription(
                           mCoupon.getmDescription())
                    .setContentUrl(Uri.parse("https://www.google.com.vn"))
                    .build();

            mShareDialog.show(linkContent);
        }
    }

    private void shareTwitter() {
        TweetComposer.Builder builder = null;
        try {
            builder = new TweetComposer.Builder(this)
                    .text(mCoupon.getmTitle()).url(new URL(mCoupon.getmImageUrl()));
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        builder.show();
    }

    private void shareInstagram()
    {
        Picasso.with(this).load(mCoupon.getmImageUrl()).into(ImageUtils.picassoImageTarget(getApplicationContext(), "coupon", "share_coupon.png"));

        ContextWrapper cw = new ContextWrapper(getApplicationContext());
        File directory = cw.getDir("coupon", Context.MODE_PRIVATE);
        File couponFile = new File(directory, "share_coupon.png");

        Uri file = Uri.fromFile(couponFile);

        Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
        shareIntent.setType("image/*");
        shareIntent.putExtra(Intent.EXTRA_STREAM, file);
        shareIntent.setPackage("com.instagram.android");
        startActivity(shareIntent);
    }

    private void shareLine()
    {
        Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
        shareIntent.setType("text/plain");
        shareIntent.putExtra(Intent.EXTRA_TEXT, mCoupon.getmImageUrl());
        shareIntent.putExtra(Intent.EXTRA_TITLE, mCoupon.getmTitle());
        shareIntent.setPackage("jp.naver.line.android");
        startActivity(shareIntent);
        // Broadcast the Intent.
//        startActivity(Intent.createChooser(shareIntent, "Share to"));
    }
}
