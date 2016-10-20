package com.hunters.pon.customs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.qrcode.QRCodeUtils;

/**
 * Created by hle59 on 10/20/2016.
 */

public class UseCouponDialog extends Dialog implements View.OnClickListener{

    private String mCode;
    private Context mContext;

    public UseCouponDialog(Context context, String code) {
        super(context);
        mContext = context;
        mCode = code;
        getWindow().setBackgroundDrawable(new ColorDrawable(ContextCompat.getColor(mContext, R.color.transparent)));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_use_coupon);

        ImageView ivQRCode = (ImageView)findViewById(R.id.iv_qr_code);
        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(this);

        new QRCodeUtils().genQRCode(mContext, mCode, ivQRCode);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.iv_back:
                dismiss();
                break;
            default:
                dismiss();
        }
    }
}
