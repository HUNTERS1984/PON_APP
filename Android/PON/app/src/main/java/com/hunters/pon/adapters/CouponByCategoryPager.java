package com.hunters.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters.pon.fragments.CouponByCategoryNearestFragment;
import com.hunters.pon.fragments.CouponByCategoryNewestFragment;
import com.hunters.pon.fragments.CouponByCategoryPopularityFragment;
import com.hunters.pon.fragments.CouponByCategoryUsedFragment;

/**
 * Created by LENOVO on 9/6/2016.
 */
public class CouponByCategoryPager extends FragmentStatePagerAdapter {
    private int mNumOfTabs;
    private long mCatId;

    public CouponByCategoryPager(FragmentManager fm, int NumOfTabs, long catId) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
        mCatId = catId;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                CouponByCategoryPopularityFragment popular = CouponByCategoryPopularityFragment.newInstance(mCatId);
                return popular;
            case 1:
                CouponByCategoryNewestFragment newest = CouponByCategoryNewestFragment.newInstance(mCatId);
                return newest;
            case 2:
                CouponByCategoryNearestFragment nearest = CouponByCategoryNearestFragment.newInstance(mCatId);
                return nearest;
            case 3:
                CouponByCategoryUsedFragment used = CouponByCategoryUsedFragment.newInstance(mCatId);
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
