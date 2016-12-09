package com.hunters.pon.fragments;

import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.hunters.pon.R;
import com.hunters.pon.activities.MainTopActivity;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.LocationUtils;
import com.hunters.pon.utils.PermissionUtils;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link TopNearestCouponFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link TopNearestCouponFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class TopNearestCouponFragment extends BaseFragment implements
        //OnLoadDataListener,
        ActivityCompat.OnRequestPermissionsResultCallback,
        GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener{
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String ARG_PARAM1 = "param1";
    private static final String ARG_PARAM2 = "param2";

    // TODO: Rename and change types of parameters
    private String mParam1;
    private String mParam2;

    private OnFragmentInteractionListener mListener;
    private LocationUtils mLocationUtils;
    private Location mUserLocation;

    public TopNearestCouponFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment TopNearestCouponFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static TopNearestCouponFragment newInstance(String param1, String param2) {
        TopNearestCouponFragment fragment = new TopNearestCouponFragment();
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

//        mDataListener = this;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        showProgressDialog(getActivity());
        checkPermission();
        View view = super.onCreateView(inflater, container, savedInstanceState);

        mLocationUtils = new LocationUtils();
        mLocationUtils.buildGoogleApiClient(getContext(), this, this);
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        mLocationUtils.connect();
    }

//    @Override
//    public void onResume() {
//        super.onResume();
//        mLnShopCatCoupons.removeAllViews();
//        onLoadData();
//    }

    @Override
    public void onStop() {
        super.onStop();
        mLocationUtils.disconnect();
    }

    @Override
    public void onLoadData() {
        if(mUserLocation != null) {
            mListCoupons = new ArrayList<>();
            String token = CommonUtils.getToken(getActivity());

            if (!token.equalsIgnoreCase("")) {
                new UserProfileAPIHelper().checkValidToken(getActivity(), token, mHanlderCheckValidToken);
            } else {
                new CouponAPIHelper().getCouponMainTop(getActivity(), Constants.TYPE_NEAREST_COUPON,
                        String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), String.valueOf(mNextPage), mHanlderGetCoupon);
            }
        }

    }

    @Override
    public void refreshData()
    {
        onLoadData();
    }

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(getActivity(), "");
                        FragmentActivity activity = getActivity();
                        if(activity != null && activity instanceof MainTopActivity) {
                            ((MainTopActivity)activity).checkToUpdateButtonLogin();
                        }
                    }
                    if(mUserLocation != null) {
                        new CouponAPIHelper().getCouponMainTop(getActivity(), Constants.TYPE_NEAREST_COUPON, String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), String.valueOf(mNextPage), mHanlderGetCoupon);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(getActivity(), getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private void checkPermission(){
        if (!PermissionUtils.newInstance().isGrantLocationPermission(getActivity())) {
            PermissionUtils.newInstance().requestLocationPermission(getActivity());
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode == PermissionUtils.REQUEST_LOCATION) {
            if(grantResults[0] == PackageManager.PERMISSION_DENIED ) {
                new DialogUtiils().showDialog(getActivity(), getString(R.string.location_denie), false);
                closeDialog();
            }
        }
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        mUserLocation = mLocationUtils.getUserLocation(getContext());
        closeDialog();
        onLoadData();

    }

    @Override
    public void onConnectionSuspended(int i) {
        new DialogUtiils().showDialog(getContext(), getString(R.string.cannot_get_user_location), false);
        closeDialog();

    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        new DialogUtiils().showDialog(getContext(), getString(R.string.cannot_get_user_location), false);
        closeDialog();
    }
}
