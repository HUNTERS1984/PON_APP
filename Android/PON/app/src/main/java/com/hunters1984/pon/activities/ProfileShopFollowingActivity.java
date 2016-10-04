package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.AddShopFollowRecyclerViewAdapter;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.ResponseShopFollowData;
import com.hunters1984.pon.api.ShopAPIHelper;
import com.hunters1984.pon.models.ShopModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class ProfileShopFollowingActivity extends BaseActivity implements OnLoadDataListener {

    private List<ShopModel> mListShops;
    private AddShopFollowRecyclerViewAdapter mAdapterShopFollow;

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
        rv.setLayoutManager(new GridLayoutManager(this, 2));

        mAdapterShopFollow = new AddShopFollowRecyclerViewAdapter(this, mListShops);
        rv.setAdapter(mAdapterShopFollow);
    }

    @Override
    public void onLoadData() {
        mListShops = new ArrayList<>();

        new ShopAPIHelper().getShopFollow(mContext, "1", mHanlderShopFollow);
//        for(int i=0; i<4;i++){
//            ShopModel shop =new ShopModel();
//            shop.setmIsShopFollow(1);
//            mListShops.add(shop);
//        }
    }

    private Handler mHanlderShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseShopFollowData shopFollow = (ResponseShopFollowData) msg.obj;
                    if (shopFollow.code == APIConstants.REQUEST_OK && shopFollow.httpCode == APIConstants.HTTP_OK) {
                        mAdapterShopFollow.updateData(shopFollow.data);
                    } else if (shopFollow.httpCode == APIConstants.HTTP_UN_AUTHORIZATION){
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
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
}
