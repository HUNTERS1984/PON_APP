package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ProfileMenuRecyclerViewAdapter;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class ProfileActivity extends BaseActivity implements OnLoadDataListener {

    private List<String> mListMenuNames;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_profile);
        mDataListener = this;
        mContext = this;
        super.onCreate(savedInstanceState);

        initLayout();

    }

    @Override
    public void onLoadData() {
        mListMenuNames = new ArrayList<>();
        mListMenuNames.add("Menu 1");
        mListMenuNames.add("Menu 2");
        mListMenuNames.add("Menu 3");
    }



    private void initLayout()
    {
        activeProfile();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_profile_menu_list);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        ProfileMenuRecyclerViewAdapter adapter = new ProfileMenuRecyclerViewAdapter(this, mListMenuNames);
        rv.setAdapter(adapter);

        ImageView ivSetting = (ImageView) findViewById(R.id.iv_setting);
        ivSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, EditProfileActivity.class, false);
            }
        });

        RelativeLayout rlShopFollow = (RelativeLayout)findViewById(R.id.rl_shop_follow);
        rlShopFollow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });

        RelativeLayout rlHistory = (RelativeLayout)findViewById(R.id.rl_history);
        rlHistory.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, HistoryActivity.class, false);
            }
        });

        RelativeLayout rlCouponsUsed = (RelativeLayout)findViewById(R.id.rl_coupons_used);
        rlCouponsUsed.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });
    }
}
