package com.hunters.pon.fragments;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.SplashSelectLoginActivity;
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCouponMainTop;
import com.hunters.pon.api.ResponseCouponMainTopData;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoginClickListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.DialogUtiils;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link BaseFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link BaseFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class BaseFragment extends Fragment {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    protected OnLoadDataListener mDataListener;

    protected List<CouponModel> mListCoupons;

    protected LinearLayout mLnShopCatCoupons;

    public BaseFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment BaseFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static BaseFragment newInstance(String param1, String param2) {
        BaseFragment fragment = new BaseFragment();
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

//        initData();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View mainView = inflater.inflate(R.layout.fragment_category_top_coupon, container, false);
        mLnShopCatCoupons = (LinearLayout) mainView.findViewById(R.id.ln_list_shop_category_coupon);

        if(mDataListener != null) {
            mDataListener.onLoadData();
        }
        return mainView;
    }

    // TODO: Rename method, update argument and hook method into UI event
    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            mListener = (OnFragmentInteractionListener) context;
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }

    protected Handler mHanlderGetCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCouponMainTopData couponData = (ResponseCouponMainTopData) msg.obj;
                    if (couponData.code == APIConstants.REQUEST_OK && couponData.httpCode == APIConstants.HTTP_OK) {
                        List<ResponseCouponMainTop> lstCouponCats = couponData.data;
                        for (ResponseCouponMainTop couponCat : lstCouponCats) {
                            View vCatCoupons = LayoutInflater.from(getActivity()).inflate(R.layout.list_coupons_of_category_layout, null, false);
                            RecyclerView rvCoupons = (RecyclerView) vCatCoupons.findViewById(R.id.rv_list_coupons);
                            TextView tvCatName = (TextView) vCatCoupons.findViewById(R.id.tv_coupon_category_name);
                            ImageView ivIconType = (ImageView) vCatCoupons.findViewById(R.id.iv_coupon_category_icon);

                            tvCatName.setText(couponCat.getmName());
                            Picasso.with(getActivity()).load(couponCat.getmIcon()).
                                    resize(CommonUtils.dpToPx(getActivity(), 20), CommonUtils.dpToPx(getActivity(), 20)).into(ivIconType);

                            LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
                            layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                            rvCoupons.setLayoutManager(layoutManager);
                            CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(getActivity(), couponCat.getmLstCoupons(), new OnLoginClickListener() {
                                @Override
                                public void onLoginClick() {
                                    startActivity(new Intent(getActivity(), SplashSelectLoginActivity.class));
                                }
                            });
                            rvCoupons.setAdapter(adapter);
                            mLnShopCatCoupons.addView(vCatCoupons);
                        }
                    } else {
                        new DialogUtiils().showDialog(getActivity(), getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(getActivity(), getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
