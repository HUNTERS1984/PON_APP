package com.hunters1984.pon.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.RelativeLayout;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ListShopRecyclerViewAdapter;
import com.hunters1984.pon.models.ShopModel;

import java.util.ArrayList;
import java.util.List;

public class ShopLocationActivity extends Activity {

    private List<ShopModel> mListShops;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_location);

        initData();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_shop);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        ListShopRecyclerViewAdapter adapter = new ListShopRecyclerViewAdapter(this, mListShops, true);
        rv.setAdapter(adapter);

        RelativeLayout rlShopLocation = (RelativeLayout)findViewById(R.id.rl_shop_location);
        rlShopLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iShopLocation = new Intent(ShopLocationActivity.this, MapShopCouponActivity.class);
                startActivity(iShopLocation);
            }
        });

    }

    private void initData()
    {
        mListShops = new ArrayList<>();

        for(int i=0; i<5; i++){
            ShopModel shop = new ShopModel();
            switch (i)
            {
                case 0:
                    shop.setmShopName("グルメ");
                    break;
                case 1:
                    shop.setmShopName("ファッション");
                    break;
                case 2:
                    shop.setmShopName("レジャー");
                    break;
                case 3:
                    shop.setmShopName("グルメ");
                    break;
                case 4:
                    shop.setmShopName("レジャー");
                    break;
            }
            mListShops.add(shop);
        }
    }
}
