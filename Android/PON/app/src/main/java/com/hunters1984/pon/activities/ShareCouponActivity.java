package com.hunters1984.pon.activities;

import android.content.Context;
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
import com.hunters1984.pon.R;
import com.hunters1984.pon.qrcode.QRCodeUtils;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

public class ShareCouponActivity extends BaseActivity {

    private ImageView mIvQRCode;
    private View mViewSNSShare;
    private Context mContext;
    private Button mBtnSNSShare, mBtnQRCodeShare;
    private CallbackManager mCallbackManager;
    private ShareDialog mShareDialog;
    private View mShareFacebook, mShareInstagram, mShareTwitter, mShareLine;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_share_coupon);
        mContext = this;
        super.onCreate(savedInstanceState);

        initLayout();
        new QRCodeUtils().genQRCode(mContext, "Hello", mIvQRCode);
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

        if (ShareDialog.canShow(ShareLinkContent.class)) {
            ShareLinkContent linkContent = new ShareLinkContent.Builder()
                    .setContentTitle("Test share")
                    .setContentDescription(
                            "Test share")
                    .setContentUrl(Uri.parse("http://developers.facebook.com/android"))
                    .build();

            mShareDialog.show(linkContent);
        }
    }

    private void shareTwitter()
    {
        TweetComposer.Builder builder = new TweetComposer.Builder(this)
                .text("just setting up my Fabric.");
        builder.show();
    }

    private void shareInstagram()
    {
//        Uri file = Uri.parse("android.resource://com.code2care.thebuddhaquotes/");
        Intent shareIntent = new Intent(android.content.Intent.ACTION_SEND);
        shareIntent.setType("image/*");
//        shareIntent.putExtra(Intent.EXTRA_STREAM,file);
        shareIntent.putExtra(Intent.EXTRA_TITLE, "YOUR TEXT HERE");
        shareIntent.setPackage("com.instagram.android");
        startActivity(shareIntent);
    }
}
