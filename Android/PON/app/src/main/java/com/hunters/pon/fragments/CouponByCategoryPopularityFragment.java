package com.hunters.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link CouponByCategoryPopularityFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link CouponByCategoryPopularityFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CouponByCategoryPopularityFragment extends BaseCouponByCategoryFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String CAT_ID = "CatId";

    // TODO: Rename and change types of parameters
    private long mCatId;


    public CouponByCategoryPopularityFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment CouponByCategoryPopularityFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static CouponByCategoryPopularityFragment newInstance(long catId) {
        CouponByCategoryPopularityFragment fragment = new CouponByCategoryPopularityFragment();
        Bundle args = new Bundle();
        args.putLong(CAT_ID, catId);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mCatId = getArguments().getLong(CAT_ID);
        }

        mDataListener = this;
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();

        new CouponAPIHelper().getCouponByCategory(getActivity(), Constants.TYPE_POPULARITY_COUPON, mCatId, "1", mHanlderGetCouponByCategory);
//        for(int i=0; i<5; i++) {
//            CouponModel coupon = new CouponModel();
//            coupon.setmTitle("タイトルが入ります");
//            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
//            coupon.setmIsFavourite((i%2==0?1:0));
//            coupon.setmIsLoginRequired((i%2==0?1:0));
//            mListCoupons.add(coupon);
//        }
    }

}