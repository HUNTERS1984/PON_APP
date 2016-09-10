package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link UsedShopCouponFilterFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link UsedShopCouponFilterFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class UsedShopCouponFilterFragment extends BaseShopCouponsFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    public UsedShopCouponFilterFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment UsedShopCouponFilterFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static UsedShopCouponFilterFragment newInstance(String param1, String param2) {
        UsedShopCouponFilterFragment fragment = new UsedShopCouponFilterFragment();
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

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("Title");
            coupon.setmDescription("Description");
            coupon.setmExpireDate("Expire : 2016.2.7");
            coupon.setmIsFavourite((i%2==0?true:false));
            coupon.setmIsLoginRequired((i%2==0?true:false));
            mListCoupons.add(coupon);
        }
    }
}
