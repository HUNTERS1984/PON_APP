package com.hunters.pon.activities;

import android.os.Bundle;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.qrcode.QRCodeUtils;

public class UseCouponActivity extends BaseActivity {

    private ImageView mIvQRCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_use_coupon);
        mContext = this;
        super.onCreate(savedInstanceState);

        initLayout();

        new QRCodeUtils().genQRCode(mContext, "Hello", mIvQRCode);
    }

    private void initLayout()
    {
        mIvQRCode = (ImageView)findViewById(R.id.iv_qr_code);
    }
}
