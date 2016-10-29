package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponPagerAdapter;
import com.hunters.pon.fragments.BaseFragment;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.Constants;

public class MainTopActivity extends BaseActivity {

    private ImageView mBtnShopSubscribe, mBtnShopLocation;

    public BaseFragment mFragmentActive;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_main);
        mContext = this;
        super.onCreate(savedInstanceState);

        initLayout();
    }

    private void initLayout()
    {
        activeHomePage();

        mBtnShopSubscribe = (ImageView) findViewById(R.id.iv_follow_shop);
        mBtnShopLocation = (ImageView)findViewById(R.id.iv_shop_location);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.popularity)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.newest)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.near)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.deals)));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        final CouponPagerAdapter adapter = new CouponPagerAdapter
                (getSupportFragmentManager(), tabLayout.getTabCount());
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });


        mBtnShopLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(MainTopActivity.this, ShopCouponByCategoryActivity.class, false);
            }
        });

        mBtnShopSubscribe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(MainTopActivity.this, AddShopFollowActivity.class, false);
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                mFragmentActive.refreshData();
                checkToUpdateButtonLogin();
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, extra.getmId());
                mContext.startActivity(iCouponDetail);
            }
        }
    }
}
