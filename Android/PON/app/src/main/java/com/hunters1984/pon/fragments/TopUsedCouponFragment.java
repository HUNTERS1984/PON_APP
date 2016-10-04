package com.hunters1984.pon.fragments;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;

import com.hunters1984.pon.R;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.api.ResponseCommon;
import com.hunters1984.pon.api.UserProfileAPIHelper;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link TopUsedCouponFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link TopUsedCouponFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class TopUsedCouponFragment extends BaseFragment implements OnLoadDataListener {
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;

    public TopUsedCouponFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment TopUsedCouponFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static TopUsedCouponFragment newInstance(String param1, String param2) {
        TopUsedCouponFragment fragment = new TopUsedCouponFragment();
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
        String token = CommonUtils.getToken(getActivity());

        if(!token.equalsIgnoreCase("")) {
            new UserProfileAPIHelper().checkValidToken(getActivity(), token, mHanlderCheckValidToken);
        } else {
            new CouponAPIHelper().getCouponMainTop(getActivity(), Constants.TYPE_USED_COUPON, "1", mHanlderGetCoupon);
        }
    }

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(getActivity(), "");
                    }
                    new CouponAPIHelper().getCouponMainTop(getActivity(), Constants.TYPE_USED_COUPON, "1", mHanlderGetCoupon);
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(getActivity(), getString(R.string.connection_failed), false);
                    break;
            }
        }
    };
}
