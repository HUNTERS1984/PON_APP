package com.hunters.pon.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ShopModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.ProgressDialogUtils;

import java.util.List;

/**
 * Created by LENOVO on 9/8/2016.
 */
public class BaseActivity extends AppCompatActivity {

    protected OnLoadDataListener mDataListener;
    protected List<CouponModel> mListCoupons;
    protected List<ShopModel> mListShops;

    private ImageView mIvHome, mIvMyFavourite, mIvProfile, mIvBack;
    private TextView mTvTitle;
    protected Context mContext;

    protected ProgressDialogUtils mProgressDialogUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initCommonLayout();
    }

    protected void initCommonLayout()
    {
        mIvHome = (ImageView)findViewById(R.id.iv_home);
        if(mIvHome != null){
            mIvHome.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(!(mContext instanceof MainTopActivity)) {
                        startActivity(mContext, MainTopActivity.class, true);
                    }
                }
            });
        }

        mIvMyFavourite = (ImageView) findViewById(R.id.iv_my_favourite);
        if (mIvMyFavourite != null) {
            mIvMyFavourite.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(!(mContext instanceof MyFavouriteActivity)) {
                        startActivity(mContext, MyFavouriteActivity.class, true);
                    }
                }
            });
        }

        mIvProfile = (ImageView) findViewById(R.id.iv_profile);
        if (mIvProfile != null){
            mIvProfile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(!(mContext instanceof ProfileActivity)) {
                        startActivity(mContext, ProfileActivity.class, true);
                    }
                }
            });
        }

        mIvBack = (ImageView)findViewById(R.id.iv_back);
        if(mIvBack != null) {
            mIvBack.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    onBackPressed();
                }
            });
        }

        mTvTitle = (TextView)findViewById(R.id.tv_title);

        if(mDataListener != null) {
            mDataListener.onLoadData();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        checkToUpdateButtonLogin();
    }

    protected void startActivity(Context context, Class<?> activity, boolean isClearTop)
    {
        Intent intent = new Intent(context, activity);
        if(isClearTop){
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        }
        startActivity(intent);
    }

    protected void startActivityForResult(Context context, Class<?> activity, int requestCode)
    {
        Intent intent = new Intent(context, activity);
        startActivityForResult(intent, requestCode);
    }

    protected void activeProfile()
    {
        mIvProfile.setImageResource(R.drawable.ic_menu_profile_select);
        mIvMyFavourite.setImageResource(R.drawable.ic_menu_favourite_unselect);
    }

    protected void activeMyFavourite()
    {
        mIvProfile.setImageResource(R.drawable.ic_menu_profile_unselect);
        mIvMyFavourite.setImageResource(R.drawable.ic_menu_favourite_select);
    }

    protected void activeHomePage()
    {
        mIvProfile.setImageResource(R.drawable.ic_menu_profile_unselect);
        mIvMyFavourite.setImageResource(R.drawable.ic_menu_favourite_unselect);
    }

    protected void setTitle(String title) {
        if(mTvTitle != null){
            mTvTitle.setText(title);
        }
    }

    protected void setIconBack(int iconBack)
    {
        if(mIvBack != null) {
            mIvBack.setImageResource(iconBack);
        }
    }

    protected void hideIconBack()
    {
        if(mIvBack != null) {
            mIvBack.setVisibility(View.GONE);
        }
    }

    protected void setOnClickIconBack(View.OnClickListener onClick)
    {
        if(mIvBack != null){
            mIvBack.setOnClickListener(onClick);
        }
    }

    public void checkToUpdateButtonLogin()
    {
        if(mIvProfile != null && mIvMyFavourite != null) {
            if (CommonUtils.isLogin(mContext)) {
                mIvProfile.setVisibility(View.VISIBLE);
                mIvMyFavourite.setVisibility(View.VISIBLE);
            } else {
                mIvProfile.setVisibility(View.GONE);
                mIvMyFavourite.setVisibility(View.GONE);
            }
        }
    }

    protected void showProgressDialog(Context context) {

        if(mProgressDialogUtils == null) {
            mProgressDialogUtils = new ProgressDialogUtils(context, "", context.getString(R.string.connecting));
        }
        mProgressDialogUtils.show();
    }

    protected void closeDialog() {
        if(mProgressDialogUtils != null){
            mProgressDialogUtils.hide();
        }
    }
}
