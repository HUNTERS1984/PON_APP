package com.hunters.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PhotoRecyclerViewAdapter;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.GoogleAnalyticUtils;

import java.util.List;

public class PhotoActivity extends BaseActivity {

    private PhotoRecyclerViewAdapter mCouponPhotoAdapter;
    private List<String> mLstPhotos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        setContentView(R.layout.activity_photo);
        super.onCreate(savedInstanceState);

        mLstPhotos = getIntent().getStringArrayListExtra(Constants.EXTRA_DATA);
        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.VIEW_PHOTO_SCREEN);
    }

    private void initLayout()
    {
        setTitle(getString(R.string.photo));

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.recycler_view_photo);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 3);
        rvCoupons.setLayoutManager(layoutManager);
        mCouponPhotoAdapter = new PhotoRecyclerViewAdapter(this, mLstPhotos, null, false);
        rvCoupons.setAdapter(mCouponPhotoAdapter);
    }
}
