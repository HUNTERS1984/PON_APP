package com.hunters.ponstaff.customs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.os.Bundle;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters.ponstaff.R;

/**
 * Created by hle59 on 10/20/2016.
 */

public class RequestCouponDialog extends Dialog implements View.OnClickListener{

    private Context mContext;

    private ImageView mIvRequestIcon;
    private Button mBtnAccept, mBtnReject, mBtnDone;
    private TextView mTvMessage;

    public RequestCouponDialog(Context context) {
        super(context);
        mContext = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.request_coupon_dialog);

        initLayout();
    }

    private void initLayout()
    {
        WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;

        getWindow().setBackgroundDrawableResource(R.drawable.background_rectangle_white);
        getWindow().setLayout((int) (width * 0.9), ViewGroup.LayoutParams.WRAP_CONTENT);

        mIvRequestIcon = (ImageView)findViewById(R.id.iv_request_icon);
        mTvMessage = (TextView)findViewById(R.id.tv_message);

        mBtnAccept = (Button)findViewById(R.id.btn_accept);
        mBtnAccept.setOnClickListener(this);

        mBtnReject = (Button)findViewById(R.id.btn_reject);
        mBtnReject.setOnClickListener(this);

        mBtnDone = (Button)findViewById(R.id.btn_done);
        mBtnDone.setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.btn_accept:
                mTvMessage.setText(mContext.getString(R.string.thank_you_my_love));
                mIvRequestIcon.setImageResource(R.drawable.ic_heart);
                mBtnAccept.setVisibility(View.GONE);
                mBtnReject.setVisibility(View.GONE);
                mBtnDone.setVisibility(View.VISIBLE);
                break;
            case R.id.btn_reject:
                mTvMessage.setText(mContext.getString(R.string.sorry_my_partner));
                mIvRequestIcon.setImageResource(R.drawable.ic_sad);
                mIvRequestIcon.setBackgroundResource(R.drawable.circle_stroke_pink_border);
                mBtnAccept.setVisibility(View.GONE);
                mBtnReject.setVisibility(View.GONE);
                mBtnDone.setVisibility(View.VISIBLE);
                mBtnDone.setBackgroundResource(R.drawable.background_rectangle_pink);
                break;
            case R.id.btn_done:
            default:
                dismiss();
        }
    }
}
