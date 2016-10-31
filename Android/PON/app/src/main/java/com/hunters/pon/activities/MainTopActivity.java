package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PagerAdapter;
import com.hunters.pon.fragments.BaseFragment;
import com.hunters.pon.fragments.TopNearestCouponFragment;
import com.hunters.pon.fragments.TopNewestCouponFragment;
import com.hunters.pon.fragments.TopPopularCouponFragment;
import com.hunters.pon.fragments.TopUsedCouponFragment;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.Constants;

public class MainTopActivity extends BaseActivity {

    private ImageView mBtnShopSubscribe, mBtnShopLocation;

    public BaseFragment mFragmentActive;

    private PagerAdapter mPagerAdapter;

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

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        setupViewPager(viewPager);
        tabLayout.setupWithViewPager(viewPager);

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

    private void setupViewPager(ViewPager viewPager) {
        mPagerAdapter = new PagerAdapter(getSupportFragmentManager());
        mPagerAdapter.addFrag(new TopPopularCouponFragment(), getString(R.string.popularity));
        mPagerAdapter.addFrag(new TopNewestCouponFragment(), getString(R.string.newest));
        mPagerAdapter.addFrag(new TopNearestCouponFragment(), getString(R.string.near));
        mPagerAdapter.addFrag(new TopUsedCouponFragment(), getString(R.string.deals));
        viewPager.setAdapter(mPagerAdapter);
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
