package com.hunters.pon.customs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.qrcode.QRCodeUtils;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by hle59 on 10/20/2016.
 */

public class UseCouponDialog extends Dialog implements View.OnClickListener{

    private String mCode;
    private Context mContext;
    private List<String> mLstStaffs;

    private ImageView mIvQRCode;
    private Handler mHandlerUseCoupon;

    public UseCouponDialog(Context context, String code, Handler handlerUseCoupon) {
        super(context);
        mContext = context;
        mCode = code;
        mHandlerUseCoupon = handlerUseCoupon;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_use_coupon);

        initLayout();
        initData();
    }

    private void initLayout()
    {
        WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;

        getWindow().setBackgroundDrawableResource(R.drawable.background_rectangle_use_coupon);
        getWindow().setLayout((int) (width * 0.8), ViewGroup.LayoutParams.WRAP_CONTENT);

        mIvQRCode = (ImageView)findViewById(R.id.iv_qr_code);
        Button btnUseCoupon = (Button)findViewById(R.id.btn_use_coupon);
        btnUseCoupon.setOnClickListener(this);

    }

    private void initData()
    {
        if(mIvQRCode != null) {
            new QRCodeUtils().genQRCode(mContext, mCode, mIvQRCode);
        }

        mLstStaffs = new ArrayList<>();
        mLstStaffs.add("Nagoya");
        mLstStaffs.add("Toyohashi");
        mLstStaffs.add("Handa");
        mLstStaffs.add("Kasugai");
        mLstStaffs.add("Touchimn");
    }

    private Handler mHandlerChooseStaff = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            Message message = Message.obtain();
            message.obj = msg.obj;
            mHandlerUseCoupon.sendMessage(message);
            dismiss();
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.btn_use_coupon:
                new DialogUtiils().showStaffDialog(mContext, mLstStaffs, mHandlerChooseStaff);
                break;
            default:
                dismiss();
        }
    }
}
