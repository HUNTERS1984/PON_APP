package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.ShopSubscribeDetailRecyclerViewAdapter;
import com.hunters1984.pon.models.ShopModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class ProfileShopFollowingActivity extends BaseActivity implements OnLoadDataListener {

    private List<ShopModel> mListShops;

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

        ShopSubscribeDetailRecyclerViewAdapter adapter = new ShopSubscribeDetailRecyclerViewAdapter(this, mListShops);
        rv.setAdapter(adapter);
    }

    @Override
    public void onLoadData() {
        mListShops = new ArrayList<>();

        for(int i=0; i<4;i++){
            ShopModel shop =new ShopModel();
            shop.setmIsShopFollow(1);
            mListShops.add(shop);
        }
    }
}
