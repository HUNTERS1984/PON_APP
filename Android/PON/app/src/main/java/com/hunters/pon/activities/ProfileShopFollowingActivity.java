package com.hunters.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.AddShopFollowRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseShopFollowData;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;

public class ProfileShopFollowingActivity extends BaseActivity implements OnLoadDataListener {

//    private List<ShopModel> mListShops;
    private AddShopFollowRecyclerViewAdapter mAdapterShopFollow;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        setContentView(R.layout.activity_profile_shop_following);
        super.onCreate(savedInstanceState);
        setTitle(getString(R.string.follow));

        initLayout();
    }

    private void initLayout()
    {
        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_profile_shop_following);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 2);
        rv.setLayoutManager(layoutManager);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mListShops.add(null);
                    mAdapterShopFollow.notifyItemInserted(mListShops.size() - 1);
                    new ShopAPIHelper().getShopFollow(mContext, String.valueOf(page + 1), mHanlderShopFollow, false);
                }
            }
        };

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(mAdapterShopFollow.getItemViewType(position)){
                    case Constants.VIEW_TYPE_ITEM:
                        return 1;
                    case Constants.VIEW_TYPE_LOADING:
                        return 2; //number of columns of the grid
                    default:
                        return -1;
                }
            }
        });
        rv.addOnScrollListener(mScrollLoadMoreData);

        mAdapterShopFollow = new AddShopFollowRecyclerViewAdapter(this, mListShops, mHandlerRefreshShopFollow);
        rv.setAdapter(mAdapterShopFollow);
    }

    @Override
    public void onLoadData() {
        mListShops = new ArrayList<>();

        new ShopAPIHelper().getShopFollow(mContext, "1", mHanlderShopFollow, true);
//        for(int i=0; i<4;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopFollow(1);
//            mListShops.add(shop);
//        }
    }

    private Handler mHanlderShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mListShops.size() > 0 && mListShops.get(mListShops.size() - 1) == null) {
                mListShops.remove(mListShops.size() - 1);
                mAdapterShopFollow.notifyItemRemoved(mListShops.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseShopFollowData shopFollow = (ResponseShopFollowData) msg.obj;
                    if (shopFollow.code == APIConstants.REQUEST_OK && shopFollow.httpCode == APIConstants.HTTP_OK) {
                        mPageTotal = shopFollow.pagination.getmPageTotal();
                        mListShops.addAll(shopFollow.data);
                        mAdapterShopFollow.updateData(mListShops);
                    } else if (shopFollow.httpCode == APIConstants.HTTP_UN_AUTHORIZATION){
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
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

    protected Handler mHandlerRefreshShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            onLoadData();
        }
    };
}
