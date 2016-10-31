package com.hunters.pon.activities;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PagerAdapter;
import com.hunters.pon.fragments.CouponByCategoryNearestFragment;
import com.hunters.pon.fragments.CouponByCategoryNewestFragment;
import com.hunters.pon.fragments.CouponByCategoryPopularityFragment;
import com.hunters.pon.fragments.CouponByCategoryUsedFragment;
import com.hunters.pon.utils.Constants;

public class CouponByCategoryDetailActivity extends BaseActivity {

    private long mCatId;
    private String mTitle;

    private PagerAdapter mPagerAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_coupon_by_category_detail);
        super.onCreate(savedInstanceState);

        mTitle = getIntent().getStringExtra(Constants.EXTRA_TITLE);
        mCatId = getIntent().getLongExtra(Constants.EXTRA_COUPON_TYPE_ID, 0);

        initLayout();
    }

    private void initLayout()
    {
        setTitle(mTitle);
        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
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
    }
}
