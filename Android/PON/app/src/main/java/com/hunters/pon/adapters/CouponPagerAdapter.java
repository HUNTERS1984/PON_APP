package com.hunters.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters.pon.fragments.TopNearestCouponFragment;
import com.hunters.pon.fragments.TopNewestCouponFragment;
import com.hunters.pon.fragments.TopPopularCouponFragment;
import com.hunters.pon.fragments.TopUsedCouponFragment;

/**
 * Created by LENOVO on 9/1/2016.
 */
public class CouponPagerAdapter extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    public CouponPagerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                TopPopularCouponFragment popular = new TopPopularCouponFragment();
                return popular;
            case 1:
                TopNewestCouponFragment newest = new TopNewestCouponFragment();
                return newest;
            case 2:
                TopNearestCouponFragment nearest = new TopNearestCouponFragment();
                return nearest;
            case 3:
                TopUsedCouponFragment used = new TopUsedCouponFragment();
                return used;
            default:
                return null;
        }
    }

    @Override
    public int getCount() {
        return mNumOfTabs;
    }
}
