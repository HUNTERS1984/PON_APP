package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponPagerAdapter;

public class MainActivity extends BaseActivity {

    private ImageView mBtnShopSubscribe, mBtnShopLocation;

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
        tabLayout.addTab(tabLayout.newTab().setText("Popular"));
        tabLayout.addTab(tabLayout.newTab().setText("Newest"));
        tabLayout.addTab(tabLayout.newTab().setText("Nearest"));
        tabLayout.addTab(tabLayout.newTab().setText("Used"));
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
                startActivity(MainActivity.this, ShopLocationActivity.class, false);
            }
        });

        mBtnShopSubscribe.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(MainActivity.this, ShopSubscribeActivity.class, false);
            }
        });
    }
}
