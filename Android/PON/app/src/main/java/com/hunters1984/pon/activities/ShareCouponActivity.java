package com.hunters1984.pon.activities;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.qrcode.QRCodeUtils;

public class ShareCouponActivity extends BaseActivity {

    private ImageView mIvQRCode;
    private View mViewSNSShare;
    private Context mContext;
    private Button mBtnSNSShare, mBtnQRCodeShare;

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
        showSNSShare();
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

    private void genQRCode(String data, ImageView ivQRCode)
    {

    }
}
