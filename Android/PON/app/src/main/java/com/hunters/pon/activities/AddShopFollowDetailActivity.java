package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.View;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PagerAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.fragments.AddShopFollowNearestFragment;
import com.hunters.pon.fragments.AddShopFollowNewestFragment;
import com.hunters.pon.fragments.AddShopFollowPopularityFragment;
import com.hunters.pon.fragments.BaseShopFollowFragment;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.protocols.OnDialogButtonConfirm;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

public class AddShopFollowDetailActivity extends BaseActivity {

    private long mTypeId;

    private Fragment mFragmentActive;
    private Object mArg;
    private PagerAdapter mShopAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_shop_follow_detail);
        super.onCreate(savedInstanceState);

        mTypeId = getIntent().getLongExtra(Constants.EXTRA_COUPON_TYPE_ID, 0);

        setTitle("グルメ");

        View search = findViewById(R.id.iv_search);
        search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(mContext, ShopCouponByCategoryActivity.class, false);
            }
        });

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        setupViewPager(viewPager);
        tabLayout.setupWithViewPager(viewPager);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mFragmentActive = mShopAdapter.getItem(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }
    //.newInstance(mTypeId)

    private void setupViewPager(ViewPager viewPager) {
        mShopAdapter = new PagerAdapter(getSupportFragmentManager());
        mShopAdapter.addFrag(AddShopFollowPopularityFragment.newInstance(mTypeId), getString(R.string.popularity));
        mShopAdapter.addFrag(AddShopFollowNewestFragment.newInstance(mTypeId), getString(R.string.newest));
        mShopAdapter.addFrag(AddShopFollowNearestFragment.newInstance(mTypeId), getString(R.string.near));
        viewPager.setAdapter(mShopAdapter);
        mFragmentActive = mShopAdapter.getItem(0);
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_FOLLOW_SHOP) {
            if (resultCode == Activity.RESULT_OK) {
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                final long shopId = extra.getmId();
                mArg = extra.getmArg();
                new DialogUtiils().showOptionDialog(mContext, mContext.getString(R.string.confirm_follow_shop), mContext.getString(R.string.ok), mContext.getString(R.string.cancel), new OnDialogButtonConfirm(){

                    @Override
                    public void onDialogButtonConfirm() {
                        new ShopAPIHelper().addShopFollow(mContext, shopId, mHanlderAddShopFollow);
                    }
                });
            }
        }

    }

    private Handler mHanlderAddShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon shopFollow = (ResponseCommon) msg.obj;
                    if (shopFollow.code == APIConstants.REQUEST_OK && shopFollow.httpCode == APIConstants.HTTP_OK){
                        ((BaseShopFollowFragment)mFragmentActive).updateStatusFollowShop(Integer.parseInt(mArg.toString()));
                    } else {
                        new DialogUtiils().showDialog(mContext, mContext.getString(R.string.token_expried), false);
                    }
                    break;
                default:
                    new DialogUtiils().showDialog(mContext, mContext.getString(R.string.connection_failed), false);
                    break;
            }

        }
    };
}
