package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters1984.pon.interfaces.OnLoadDataListener;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link UsedCouponFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link UsedCouponFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class UsedCouponFragment extends BaseFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    public UsedCouponFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment UsedCouponFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static UsedCouponFragment newInstance(String param1, String param2) {
        UsedCouponFragment fragment = new UsedCouponFragment();
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
        for(int i=0;i <3; i++) {
            View vCatCoupons = LayoutInflater.from(getActivity()).inflate(R.layout.list_shops_of_category_layout, null, false);
            RecyclerView rvCoupons = (RecyclerView) vCatCoupons.findViewById(R.id.rv_list_coupons);
            TextView tvCatName = (TextView)vCatCoupons.findViewById(R.id.tv_shop_category_name);
            if(i==0) {
                tvCatName.setText("Restaurant");
            } else if(i==1) {
                tvCatName.setText("Clothes");
            } else {
                tvCatName.setText("Music");
            }
            LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
            layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
            rvCoupons.setLayoutManager(layoutManager);
            CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(getActivity(), mListCoupons);
            rvCoupons.setAdapter(adapter);
            mLnShopCatCoupons.addView(vCatCoupons);

        }
    }
}
