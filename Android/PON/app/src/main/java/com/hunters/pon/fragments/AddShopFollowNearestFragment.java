package com.hunters.pon.fragments;

import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.hunters.pon.R;
import com.hunters.pon.activities.AddShopFollowDetailActivity;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.models.ShopModel;
import com.hunters.pon.protocols.OnLoadMoreListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.LocationUtils;
import com.hunters.pon.utils.PermissionUtils;

import java.util.ArrayList;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link AddShopFollowNearestFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link AddShopFollowNearestFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class AddShopFollowNearestFragment extends BaseShopFollowFragment implements
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

    public AddShopFollowNearestFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @param param1 Parameter 1.
     * @param param2 Parameter 2.
     * @return A new instance of fragment AddShopFollowNearestFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static AddShopFollowNearestFragment newInstance(long catId) {
        AddShopFollowNearestFragment fragment = new AddShopFollowNearestFragment();
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
        ((AddShopFollowDetailActivity)getActivity()).mFragmentActive = this;

        mLoadMoreData = this;

        mLocationUtils = new LocationUtils();
        mLocationUtils.buildGoogleApiClient(getContext(), this, this);
        showProgressDialog(getActivity());
        checkPermission();
    }

//    @Override
//    public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                             Bundle savedInstanceState) {
//        View view = inflater.inflate(R.layout.fragment_nearest_shop_subscribe, container, false);
//        RecyclerView rv = (RecyclerView)view.findViewById(R.id.recycler_view_shop_subscribe);
//        rv.setLayoutManager(new GridLayoutManager(view.getContext(), 2));
//
//        AddShopFollowRecyclerViewAdapter adapter = new AddShopFollowRecyclerViewAdapter(view.getContext(), mListShops);
//        rv.setAdapter(adapter);
//        return view;
//    }

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
    public void updateStatusFollowShop(int position)
    {
        if(mLstShopFollows != null) {
            ShopModel shop = mLstShopFollows.get(position);
            boolean isShopFollow = shop.getmIsShopFollow();
            mLstShopFollows.get(position).setmIsShopFollow(!isShopFollow);
            mAdapterShopFollow.notifyDataSetChanged();
        }
    }

    public void loadData() {
        mLstShopFollows = new ArrayList<>();
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_NEAREST_COUPON, mCatId, String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), "1", mHanlderShopFollow, true);
    }

    @Override
    public void onLoadMoreData(int page) {
        new ShopAPIHelper().getShopFollowCategory(getActivity(), Constants.TYPE_NEAREST_COUPON, mCatId, String.valueOf(mUserLocation.getLatitude()), String.valueOf(mUserLocation.getLongitude()), String.valueOf(page + 1), mHanlderShopFollow, false);
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
        loadData();

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
