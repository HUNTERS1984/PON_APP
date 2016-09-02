package com.hunters1984.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters1984.pon.fragments.NearestCouponFragment;
import com.hunters1984.pon.fragments.NewestCouponFragment;
import com.hunters1984.pon.fragments.PopularCouponFragment;
import com.hunters1984.pon.fragments.UsedCouponFragment;

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
                PopularCouponFragment popular = new PopularCouponFragment();
                return popular;
            case 1:
                NewestCouponFragment newest = new NewestCouponFragment();
                return newest;
            case 2:
                NearestCouponFragment nearest = new NearestCouponFragment();
                return nearest;
            case 3:
                UsedCouponFragment used = new UsedCouponFragment();
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
