package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PagerAdapter;
import com.hunters.pon.fragments.BaseFragment;
import com.hunters.pon.fragments.TopNearestCouponFragment;
import com.hunters.pon.fragments.TopNewestCouponFragment;
import com.hunters.pon.fragments.TopPopularCouponFragment;
import com.hunters.pon.fragments.TopUsedCouponFragment;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.KeyboardUtils;

public class MainTopActivity extends BaseActivity {

    private ImageView mBtnShopSubscribe, mBtnShopLocation;
    private EditText mEdtSearch;
    public Fragment mFragmentActive;
    private PagerAdapter mPagerAdapter;

    private boolean mDoubleBackToExit = false;

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

        mEdtSearch = (EditText) findViewById(R.id.edt_search);
        mEdtSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if(actionId == EditorInfo.IME_ACTION_SEARCH){
                    performSearch();
                    return true;
                }
                return false;
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

    private void performSearch()
    {
        new KeyboardUtils().hideKeyboard(mContext);
        String query = mEdtSearch.getText().toString();
        Intent iSearch = new Intent(MainTopActivity.this, SearchActivity.class);
        iSearch.putExtra(Constants.EXTRA_DATA, query);
        startActivity(iSearch);
    }

    private void setupViewPager(ViewPager viewPager) {
        mPagerAdapter = new PagerAdapter(getSupportFragmentManager());
        mPagerAdapter.addFrag(new TopPopularCouponFragment(), getString(R.string.popularity));
        mPagerAdapter.addFrag(new TopNewestCouponFragment(), getString(R.string.newest));
        mPagerAdapter.addFrag(new TopNearestCouponFragment(), getString(R.string.near));
        mPagerAdapter.addFrag(new TopUsedCouponFragment(), getString(R.string.deals));
        viewPager.setAdapter(mPagerAdapter);
        mFragmentActive = mPagerAdapter.getItem(0);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                ((BaseFragment)mFragmentActive).refreshData();
                checkToUpdateButtonLogin();
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, extra.getmId());
                mContext.startActivity(iCouponDetail);
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (mDoubleBackToExit) {
            super.onBackPressed();
            return;
        }

        this.mDoubleBackToExit = true;
        Toast.makeText(this, mContext.getString(R.string.back_to_exit), Toast.LENGTH_SHORT).show();

        new Handler().postDelayed(new Runnable() {

            @Override
            public void run() {
                mDoubleBackToExit = false;
            }
        }, 2000);
    }
}
