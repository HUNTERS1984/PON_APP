package com.hunters1984.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters1984.pon.fragments.NearestShopCouponFilterFragment;
import com.hunters1984.pon.fragments.NewestShopCouponFilterFragment;
import com.hunters1984.pon.fragments.PopularShopCouponFilterFragment;
import com.hunters1984.pon.fragments.UsedShopCouponFilterFragment;

/**
 * Created by LENOVO on 9/6/2016.
 */
public class ShopCouponFilterPager extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    public ShopCouponFilterPager(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                PopularShopCouponFilterFragment popular = new PopularShopCouponFilterFragment();
                return popular;
            case 1:
                NewestShopCouponFilterFragment newest = new NewestShopCouponFilterFragment();
                return newest;
            case 2:
                NearestShopCouponFilterFragment nearest = new NearestShopCouponFilterFragment();
                return nearest;
            case 3:
                UsedShopCouponFilterFragment used = new UsedShopCouponFilterFragment();
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
