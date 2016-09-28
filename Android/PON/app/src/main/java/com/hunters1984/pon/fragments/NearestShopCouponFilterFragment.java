package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link NearestShopCouponFilterFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link NearestShopCouponFilterFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class NearestShopCouponFilterFragment extends BaseShopCouponsFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;


    public NearestShopCouponFilterFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment NearestShopCouponFilterFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static NearestShopCouponFilterFragment newInstance(String param1, String param2) {
        NearestShopCouponFilterFragment fragment = new NearestShopCouponFilterFragment();
        Bundle args = new Bundle();
        args.putString(ARG_PARAM1, param1);
        args.putString(ARG_PARAM2, param2);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam1 = getArguments().getString(ARG_PARAM1);
            mParam2 = getArguments().getString(ARG_PARAM2);
        }
        mDataListener = this;
    }

    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("タイトルが入ります");
            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
            coupon.setmIsFavourite((i%2==0?1:0));
            coupon.setmIsLoginRequired((i%2==0?1:0));
            mListCoupons.add(coupon);
        }
    }
}
