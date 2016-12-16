package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.CategoryRecyclerViewAdapter;
import com.hunters.pon.adapters.DividerItemDecoration;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCategoryData;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.CategoryModel;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.hunters.pon.utils.KeyboardUtils;

import java.util.ArrayList;
import java.util.List;

public class ShopCouponByCategoryActivity extends Activity {

    private List<CategoryModel> mLstCategories;
    private CategoryRecyclerViewAdapter mAdapterCategory;
    private EditText mEdtSearch;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;

    private int mPageTotal;
    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_coupon_by_category);
        mContext = this;

        initData();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_coupon_type);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        rv.setLayoutManager(layoutManager);

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        mAdapterCategory = new CategoryRecyclerViewAdapter(this, mLstCategories);
        rv.setAdapter(mAdapterCategory);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mLstCategories.add(null);
                    mAdapterCategory.notifyItemInserted(mLstCategories.size() - 1);
                    new CouponAPIHelper().getCategory(mContext, String.valueOf(page + 1), mHanlderGetCategory, false);
                }
            }
        };
        rv.addOnScrollListener(mScrollLoadMoreData);

        RelativeLayout rlShopLocation = (RelativeLayout)findViewById(R.id.rl_shop_location);
        rlShopLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iShopLocation = new Intent(ShopCouponByCategoryActivity.this, MapShopCouponActivity.class);
                startActivity(iShopLocation);
            }
        });

        mEdtSearch = (EditText)findViewById(R.id.edt_search);
        mEdtSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if(actionId == EditorInfo.IME_ACTION_SEARCH){
                    performSearch();
                    return true;
                }
                return false;
            }
        });

        TextView tvCancel = (TextView)findViewById(R.id.tv_cancel);
        tvCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            finish();
            }
        });

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.COUPON_CATEGORY_SCREEN);
    }

    private void initData()
    {
        mLstCategories = new ArrayList<>();
        new CouponAPIHelper().getCategory(mContext, "1", mHanlderGetCategory, true);

    }

    private void performSearch()
    {
        new KeyboardUtils().hideKeyboard(mContext);
        String query = mEdtSearch.getText().toString();
        Intent iSearch = new Intent(ShopCouponByCategoryActivity.this, SearchActivity.class);
        iSearch.putExtra(Constants.EXTRA_DATA, query);
        startActivity(iSearch);
    }

    private Handler mHanlderGetCategory = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mLstCategories.size() > 0 && mLstCategories.get(mLstCategories.size() - 1) == null) {
                mLstCategories.remove(mLstCategories.size() - 1);
                mAdapterCategory.notifyItemRemoved(mLstCategories.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCategoryData couponType = (ResponseCategoryData) msg.obj;
                    if (couponType.code == APIConstants.REQUEST_OK && couponType.httpCode == APIConstants.HTTP_OK) {
                        mPageTotal = couponType.pagination.getmPageTotal();
                        mLstCategories.addAll(couponType.data);
                        mAdapterCategory.updateData(mLstCategories);
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
