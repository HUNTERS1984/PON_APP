package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.SearchCouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCouponDetail;
import com.hunters.pon.api.ResponseSearchCouponData;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class SearchActivity extends BaseActivity implements OnLoadDataListener {

    private SearchCouponRecyclerViewAdapter mAdapterCoupon;
    private RecyclerView mRecyclerViewCoupon;;

    private String mQuery = "";

//    private boolean mIsLoading;
//    private int mLastVisibleItem, mTotalItemCount;
    private List<ResponseCouponDetail> mLstSearchCoupons;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
//        mDataListener = this;
        setContentView(R.layout.activity_search);
        mQuery = getIntent().getStringExtra(Constants.EXTRA_DATA);
        super.onCreate(savedInstanceState);

        setTitle(mQuery);

        mRecyclerViewCoupon = (RecyclerView)findViewById(R.id.recycler_search);
        final GridLayoutManager layoutManager = new GridLayoutManager(this, 2);
        mRecyclerViewCoupon.setLayoutManager(layoutManager);
        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {

                if(page < mPageTotal) {
                    mLstSearchCoupons.add(null);
                    mAdapterCoupon.notifyItemInserted(mLstSearchCoupons.size() - 1);
                    new CouponAPIHelper().searchCoupon(mContext, mQuery, String.valueOf(page + 1), mHanlderSearchCoupon, false);
                }
            }
        };
        mRecyclerViewCoupon.addOnScrollListener(mScrollLoadMoreData);

//        mRecyclerViewCoupon.addOnScrollListener(new RecyclerView.OnScrollListener() {
//            @Override
//            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
//                super.onScrolled(recyclerView, dx, dy);
//
//                mTotalItemCount = layoutManager.getItemCount();
//                mLastVisibleItem = layoutManager.findLastVisibleItemPosition();
//
////                if (mTotalItemCount < mPreviousTotalItemCount) {
////                    this.mCurrentPage = this.startingPageIndex;
////                    this.mPreviousTotalItemCount = mTotalItemCount;
////                    if (mTotalItemCount == 0) {
////                        this.loading = true;
////                    }
////                }
////                // If it’s still loading, we check to see if the dataset count has
////                // changed, if so we conclude it has finished loading and update the current page
////                // number and total item count.
////                if (mIsLoading && (mTotalItemCount > mPreviousTotalItemCount)) {
////                    mIsLoading = false;
////                    mPreviousTotalItemCount = mTotalItemCount;
////                }

//                if (!mIsLoading && mTotalItemCount <= (mLastVisibleItem + Constants.VISIBLE_THRESHOLD)) {
////                    mCurrentPage++;
//                    onLoadMore();
//                    mIsLoading = true;
//                }
//            }
//        });


        mLstSearchCoupons = new ArrayList<>();
        mAdapterCoupon = new SearchCouponRecyclerViewAdapter((Activity)mContext, mLstSearchCoupons);
        mRecyclerViewCoupon.setAdapter(mAdapterCoupon);

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(mAdapterCoupon.getItemViewType(position)){
                    case Constants.VIEW_TYPE_ITEM:
                        return 1;
                    case Constants.VIEW_TYPE_LOADING:
                        return 2; //number of columns of the grid
                    default:
                        return -1;
                }
            }
        });


    }

    @Override
    protected void onResume() {
        super.onResume();
        onLoadData();
    }

    @Override
    public void onLoadData() {
        if(mLstSearchCoupons == null) {
            mLstSearchCoupons = new ArrayList<>();
        }
        mLstSearchCoupons.clear();
        new CouponAPIHelper().searchCoupon(mContext, mQuery, "1", mHanlderSearchCoupon, true);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                checkToUpdateButtonLogin();
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, extra.getmId());
                mContext.startActivity(iCouponDetail);
            }
        }
    }

    //    @Override
//    public void onLoadMore() {
//
//    }

    private Handler mHanlderSearchCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mLstSearchCoupons.size() > 0 && mLstSearchCoupons.get(mLstSearchCoupons.size() - 1) == null) {
                mLstSearchCoupons.remove(mLstSearchCoupons.size() - 1);
                mAdapterCoupon.notifyItemRemoved(mLstSearchCoupons.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseSearchCouponData couponData = (ResponseSearchCouponData) msg.obj;
                    if (couponData.code == APIConstants.REQUEST_OK && couponData.httpCode == APIConstants.HTTP_OK) {
                        if(couponData.data != null && couponData.data.size() > 0) {
                            mPageTotal = couponData.pagination.getmPageTotal();
                            mLstSearchCoupons.addAll(couponData.data);
                            mAdapterCoupon.updateData(mLstSearchCoupons);
                        } else {
                            new DialogUtiils().showDialog(mContext, getString(R.string.no_record_found), true);
                        }
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    mScrollLoadMoreData.adjustCurrentPage();
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
            mScrollLoadMoreData.setLoaded();
        }
    };


}
