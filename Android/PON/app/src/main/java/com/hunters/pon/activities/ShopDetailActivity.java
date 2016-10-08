package com.hunters.pon.activities;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.adapters.PhotoRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseShopDetail;
import com.hunters.pon.api.ResponseShopDetailData;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

public class ShopDetailActivity extends AppCompatActivity implements OnLoadDataListener, OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback {

    private List<String> mLstPhotos;
    private List<CouponModel> mLstCoupons;
    private GoogleMap mGoogleMap;
    private Context mContext;

    private long mShopId;
    private double mShopLat, mShopLng;
    private String mPhone, mShopName, mShopDirection;

    private CouponRecyclerViewAdapter mAdapterCoupon;
    private PhotoRecyclerViewAdapter mAdapterShopPhoto;
    private TextView mTvShopName, mTvShopType, mTvShopId, mTvShopAddress, mTvShopHelpDirection,
                     mTvShopOperationTime, mTvShopCloseDate, mTvShopAvgBudget, mTvShopPhone;
    private ImageView mIvShopAvatar, mIvShopLogo;
    private ProgressBar mProgressBarLoadingPhoto;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_detail);
        mContext = this;

        mShopId = getIntent().getLongExtra(Constants.EXTRA_SHOP_ID, 0);
        onLoadData();

        initLayout();

    }

    private void initLayout()
    {
        try {
            if (mGoogleMap == null) {
                ((MapFragment) getFragmentManager().
                        findFragmentById(R.id.map_shop)).getMapAsync(this);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        mIvShopAvatar = (ImageView) findViewById(R.id.iv_shop_avatar_photo);
        mIvShopLogo = (ImageView)findViewById(R.id.iv_shop_logo);
        mProgressBarLoadingPhoto = (ProgressBar)findViewById(R.id.progress_bar_loading_shop_photo);

        mTvShopName = (TextView) findViewById(R.id.tv_shop_name);
        mTvShopType = (TextView) findViewById(R.id.tv_shop_type);
        mTvShopId = (TextView) findViewById(R.id.tv_shop_id);
        mTvShopAddress = (TextView)findViewById(R.id.tv_shop_address);
        mTvShopHelpDirection = (TextView)findViewById(R.id.tv_shop_help_direction);
        mTvShopOperationTime = (TextView)findViewById(R.id.tv_shop_operation_time);
        mTvShopCloseDate = (TextView) findViewById(R.id.tv_shop_close_date);
        mTvShopAvgBudget = (TextView)findViewById(R.id.tv_shop_avg_budget);
        mTvShopPhone = (TextView)findViewById(R.id.tv_shop_phone);

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.recycler_view_coupons_of_shop);
        LinearLayoutManager lmCoupons = new LinearLayoutManager(this);
        lmCoupons.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvCoupons.setLayoutManager(lmCoupons);
        mAdapterCoupon = new CouponRecyclerViewAdapter(this, mLstCoupons);
        rvCoupons.setAdapter(mAdapterCoupon);

        RecyclerView rvPhotoShops = (RecyclerView) findViewById(R.id.recycler_view_photo_of_shop);
        GridLayoutManager lmShop = new GridLayoutManager(this, 3);
        rvPhotoShops.setLayoutManager(lmShop);
        mAdapterShopPhoto = new PhotoRecyclerViewAdapter(this, mLstPhotos, false);
        rvPhotoShops.setAdapter(mAdapterShopPhoto);

        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });

        View callShop = findViewById(R.id.ln_call_shop);
        callShop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + mPhone));
                startActivity(intent);
            }
        });

        View showMapShop = findViewById(R.id.ln_map_shop);
        showMapShop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String uriBegin = "geo:" + mShopLat + "," + mShopLng;
                String query = mShopLat + "," + mShopLng + "(" + mShopName + ")";
                String encodedQuery = Uri.encode(query);
                String uriString = uriBegin + "?q=" + encodedQuery + "&z=16";
                Uri uri = Uri.parse(uriString);
                Intent intent = new Intent(android.content.Intent.ACTION_VIEW, uri);
                startActivity(intent);
            }
        });
        View shareShop = findViewById(R.id.ln_share_shop);
        shareShop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent sharingIntent = new Intent(Intent.ACTION_SEND);
                sharingIntent.setType("text/plain");
                sharingIntent.putExtra(Intent.EXTRA_SUBJECT, mShopName);
                sharingIntent.putExtra(Intent.EXTRA_TEXT, mShopDirection);
                startActivity(Intent.createChooser(sharingIntent,"Share to"));
            }
        });
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        showShopMap(mShopLat, mShopLng);
    }

    @Override
    public void onLoadData() {
        mLstCoupons = new ArrayList<>();
        mLstPhotos = new ArrayList<>();

        new ShopAPIHelper().getShopDetail(mContext, mShopId, mHanlderShopDetail);
    }

    private Handler mHanlderShopDetail = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseShopDetailData data = (ResponseShopDetailData) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK) {
                        ResponseShopDetail shop = data.data;
                        popularLayout(shop);
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private void popularLayout(ResponseShopDetail shop)
    {
        mPhone = shop.getmPhone();
        mShopName = shop.getmShopName();
        mShopDirection = shop.getmHelpDirection();

        Picasso.with(mContext).load(shop.getmShopPhotoAvarta())
                .resize(CommonUtils.dpToPx(mContext, 220), CommonUtils.dpToPx(mContext, 200))
                .centerCrop().into(mIvShopAvatar, new Callback() {
            @Override
            public void onSuccess() {
                mProgressBarLoadingPhoto.setVisibility(View.GONE);
            }

            @Override
            public void onError() {
                mProgressBarLoadingPhoto.setVisibility(View.VISIBLE);
            }
        });

        Picasso.with(mContext).load(shop.getmShopCat().getmIcon())
                .resize(CommonUtils.dpToPx(mContext, 90), CommonUtils.dpToPx(mContext, 90))
                .centerCrop().into(mIvShopLogo);

        mTvShopName.setText(shop.getmShopName());
        mTvShopType.setText(shop.getmShopCat().getmName());
        mTvShopId.setText(String.valueOf(shop.getmId()));
        mTvShopAddress.setText(shop.getmAddress());
        mTvShopHelpDirection.setText(shop.getmHelpDirection());
        mTvShopOperationTime.setText(shop.getmOperationStartTime() + "~" + shop.getmOperationEndTime());
        mTvShopCloseDate.setText(shop.getmCloseDate());
        mTvShopAvgBudget.setText(getString(R.string.shop_bill).replace("%s",String.valueOf(shop.getmAveBudget())));
        mTvShopPhone.setText(shop.getmPhone());

        //Show List Coupons of Shop
        mAdapterCoupon.updateData(shop.getmLstCouponOfShop());

        //Show List Photo Of Shop
        mLstPhotos = shop.getmLstShopPhoto();
        mAdapterShopPhoto.updateData(mLstPhotos, false, "");

        //Show Map of Shop
        mShopLat = Double.parseDouble(shop.getmLatitude().toString());
        mShopLng = Double.parseDouble(shop.getmLongitude().toString());
        showShopMap(mShopLat, mShopLng);
    }

    private void showShopMap(double lat, double lng)
    {
        if (mGoogleMap != null) {
            LatLng shopLoc = new LatLng(lat, lng);
            CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(shopLoc, 10);
            mGoogleMap.moveCamera(camera);
            mGoogleMap.addMarker(new MarkerOptions().position(shopLoc));
        }
    }
}
