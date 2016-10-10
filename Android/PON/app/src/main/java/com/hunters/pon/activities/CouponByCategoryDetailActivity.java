package com.hunters.pon.activities;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;

import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponByCategoryPager;
import com.hunters.pon.utils.Constants;

public class CouponByCategoryDetailActivity extends BaseActivity {

    private long mCatId;
    private String mTitle;

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
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.popularity)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.newest)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.near)));
        tabLayout.addTab(tabLayout.newTab().setText(getString(R.string.deals)));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        final ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        final CouponByCategoryPager adapter = new CouponByCategoryPager
                (getSupportFragmentManager(), tabLayout.getTabCount(), mCatId);
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
    }
}