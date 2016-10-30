package com.hunters.pon.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by LENOVO on 9/1/2016.
 */
public class ShopFollowPagerAdapter extends FragmentPagerAdapter {
    private final List<Fragment> mFragmentList = new ArrayList<>();
    private final List<String> mFragmentTitleList = new ArrayList<>();

    public ShopFollowPagerAdapter(FragmentManager manager) {
        super(manager);
    }

    @Override
    public Fragment getItem(int position) {
        return mFragmentList.get(position);
    }

    @Override
    public int getCount() {
        return mFragmentList.size();
    }

    public void addFrag(Fragment fragment, String title) {
        mFragmentList.add(fragment);
        mFragmentTitleList.add(title);
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mFragmentTitleList.get(position);
    }

//    @Override
//    public Fragment getItem(int position) {
//
//        switch (position) {
//            case 0:
//                AddShopFollowPopularityFragment popular = AddShopFollowPopularityFragment.newInstance(mCouponTypeId);
//                return popular;
//            case 1:
//                AddShopFollowNewestFragment newest = AddShopFollowNewestFragment.newInstance(mCouponTypeId);
//                return newest;
//            case 2:
//                AddShopFollowNearestFragment nearest = AddShopFollowNearestFragment.newInstance(mCouponTypeId);
//                return nearest;
//            default:
//                return null;
//        }
//    }
//
//    @Override
//    public int getCount() {
//        return mNumOfTabs;
//    }
}
