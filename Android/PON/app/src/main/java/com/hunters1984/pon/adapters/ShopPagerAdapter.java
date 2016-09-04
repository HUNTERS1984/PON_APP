package com.hunters1984.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.hunters1984.pon.fragments.NearestShopSubscribeFragment;
import com.hunters1984.pon.fragments.NewestShopSubscribeFragment;
import com.hunters1984.pon.fragments.PopularShopSubscribeFragment;

/**
 * Created by LENOVO on 9/1/2016.
 */
public class ShopPagerAdapter extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    public ShopPagerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                PopularShopSubscribeFragment popular = new PopularShopSubscribeFragment();
                return popular;
            case 1:
                NewestShopSubscribeFragment newest = new NewestShopSubscribeFragment();
                return newest;
            case 2:
                NearestShopSubscribeFragment nearest = new NearestShopSubscribeFragment();
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
