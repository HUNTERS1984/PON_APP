package com.hunters.pon.fragments;

import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.hunters.pon.R;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.LocationUtils;
import com.hunters.pon.utils.PermissionUtils;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link CouponByCategoryNearestFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link CouponByCategoryNearestFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CouponByCategoryNearestFragment extends BaseCouponByCategoryFragment implements
        OnLoadMoreListener,
        ActivityCompat.OnRequestPermissionsResultCallback,
        GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener{
    // TODO: Rename parameter arguments, choose names that match
    // the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
    private static final String CAT_ID = "CatId";

    // TODO: Rename and change types of parameters
    private long mCatId;


    private LocationUtils mLocationUtils;
    private Location mUserLocation;

    public CouponByCategoryNearestFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment CouponByCategoryNearestFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static CouponByCategoryNearestFragment newInstance(long catId) {
        CouponByCategoryNearestFragment fragment = new CouponByCategoryNearestFragment();
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
        mLoadMoreData = this;

        mLocationUtils = new LocationUtils();
        mLocationUtils.buildGoogleApiClient(getContext(), this, this);
        showProgressDialog(getActivity());
        checkPermission();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        showProgressDialog(getActivity());
        checkPermission();
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();
        mLocationUtils.connect();
    }

    @Override
    public void onStop() {
        super.onStop();
        mLocationUtils.disconnect();
    }

    @Override
    public void onLoadData() {
        if(mUserLocation != null) {
            mListCoupons = new ArrayList<>();

            new CouponAPIHelper().getCouponByCategory(getActivity(), Constants.TYPE_NEAREST_COUPON, mCatId, String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), "1", mHanlderGetCouponByCategory, true);
        }
//        for(int i=0; i<5; i++) {
//            CouponModel coupon = new CouponModel();
//            coupon.setmTitle("タイトルが入ります");
//            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
//            coupon.setmIsFavourite((i%2==0?1:0));
//            coupon.setmIsLoginRequired((i%2==0?1:0));
//            mListCoupons.add(coupon);
//        }
    }

    @Override
    public void onLoadMoreData(int page) {
        if(mUserLocation != null) {
            new CouponAPIHelper().getCouponByCategory(getActivity(), Constants.TYPE_NEAREST_COUPON, mCatId, String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), String.valueOf(page + 1), mHanlderGetCouponByCategory, false);
        }
    }

    @Override
    public void refreshData(){
        onLoadData();
    }

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
