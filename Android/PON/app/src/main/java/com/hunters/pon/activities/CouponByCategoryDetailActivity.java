package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PagerAdapter;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.fragments.BaseCouponByCategoryFragment;
import com.hunters.pon.fragments.CouponByCategoryNearestFragment;
import com.hunters.pon.fragments.CouponByCategoryNewestFragment;
import com.hunters.pon.fragments.CouponByCategoryPopularityFragment;
import com.hunters.pon.fragments.CouponByCategoryUsedFragment;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.GoogleAnalyticUtils;

public class CouponByCategoryDetailActivity extends BaseActivity {

    private long mCatId;
    private String mTitle;

    private PagerAdapter mPagerAdapter;

    public Fragment mFragmentActive;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_coupon_by_category_detail);
        super.onCreate(savedInstanceState);

        mTitle = getIntent().getStringExtra(Constants.EXTRA_TITLE);
        mCatId = getIntent().getLongExtra(Constants.EXTRA_COUPON_TYPE_ID, 0);

        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.COUPON_CATEGORY_DETAIL_SCREEN);
    }

    private void initLayout()
    {
        setTitle(mTitle);
        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mFragmentActive = mPagerAdapter.getItem(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        setupViewPager(viewPager);
        tabLayout.setupWithViewPager(viewPager);
    }

    private void setupViewPager(ViewPager viewPager) {
        mPagerAdapter = new PagerAdapter(getSupportFragmentManager());
        mPagerAdapter.addFrag(CouponByCategoryPopularityFragment.newInstance(mCatId), getString(R.string.popularity));
        mPagerAdapter.addFrag(CouponByCategoryNewestFragment.newInstance(mCatId), getString(R.string.newest));
        mPagerAdapter.addFrag(CouponByCategoryNearestFragment.newInstance(mCatId), getString(R.string.near));
        mPagerAdapter.addFrag(CouponByCategoryUsedFragment.newInstance(mCatId), getString(R.string.deals));
        viewPager.setAdapter(mPagerAdapter);
        mFragmentActive = mPagerAdapter.getItem(0);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                ((BaseCouponByCategoryFragment)mFragmentActive).refreshData();
                checkToUpdateButtonLogin();
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, extra.getmId());
                mContext.startActivity(iCouponDetail);
            }
        }
    }
}
