package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.Constants;

import java.util.ArrayList;

;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link TopNewestCouponFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link TopNewestCouponFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class TopNewestCouponFragment extends BaseFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    public TopNewestCouponFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment TopNewestCouponFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static TopNewestCouponFragment newInstance(String param1, String param2) {
        TopNewestCouponFragment fragment = new TopNewestCouponFragment();
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
        new CouponAPIHelper().getCouponMainTop(getActivity(), Constants.TYPE_NEWEST_COUPON, "1", mHanlderGetCoupon);

//        for(int i=0;i <3; i++) {
//            View vCatCoupons = LayoutInflater.from(getActivity()).inflate(R.layout.list_coupons_of_category_layout, null, false);
//            RecyclerView rvCoupons = (RecyclerView) vCatCoupons.findViewById(R.id.rv_list_coupons);
//            TextView tvCatName = (TextView)vCatCoupons.findViewById(R.id.tv_coupon_category_name);
//            if(i==0) {
//                tvCatName.setText("グルメ");
//            } else if(i==1) {
//                tvCatName.setText("ファッション");
//            } else {
//                tvCatName.setText("音楽");
//            }
//            LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
//            layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
//            rvCoupons.setLayoutManager(layoutManager);
//            CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(getActivity(), mListCoupons);
//            rvCoupons.setAdapter(adapter);
//            mLnShopCatCoupons.addView(vCatCoupons);
//
//        }
    }
}
