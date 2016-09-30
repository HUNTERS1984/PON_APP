package com.hunters1984.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters1984.pon.fragments.AddShopFollowNearestFragment;
import com.hunters1984.pon.fragments.AddShopFollowNewestFragment;
import com.hunters1984.pon.fragments.AddShopFollowPopularityFragment;

/**
 * Created by LENOVO on 9/1/2016.
 */
public class ShopFollowPagerAdapter extends FragmentStatePagerAdapter {
    private int mNumOfTabs;
    private double mCouponTypeId;

    public ShopFollowPagerAdapter(FragmentManager fm, int NumOfTabs, double couponTypeId) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
        mCouponTypeId = couponTypeId;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                AddShopFollowPopularityFragment popular = AddShopFollowPopularityFragment.newInstance(mCouponTypeId);
                return popular;
            case 1:
                AddShopFollowNewestFragment newest = AddShopFollowNewestFragment.newInstance(mCouponTypeId);
                return newest;
            case 2:
                AddShopFollowNearestFragment nearest = AddShopFollowNearestFragment.newInstance(mCouponTypeId);
                return nearest;
            default:
                return null;
        }
    }

    @Override
    public int getCount() {
        return mNumOfTabs;
    }
}
