package com.hunters.pon.activities;

import android.os.Bundle;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.qrcode.QRCodeUtils;
import com.hunters.pon.utils.Constants;

public class UseCouponActivity extends BaseActivity {

    private ImageView mIvQRCode;
    private String mCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_use_coupon);
        mContext = this;
        super.onCreate(savedInstanceState);

        mCode = getIntent().getStringExtra(Constants.EXTRA_DATA);
        initLayout();

        if (mCode != null) {
            new QRCodeUtils().genQRCode(mContext, mCode, mIvQRCode);
        }
    }

    private void initLayout()
    {
        mIvQRCode = (ImageView)findViewById(R.id.iv_qr_code);
    }
}
