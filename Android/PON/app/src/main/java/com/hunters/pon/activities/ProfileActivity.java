package com.hunters.pon.activities;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.DividerItemDecoration;
import com.hunters.pon.adapters.ProfileMenuRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.ResponseProfileData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.UserModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

public class ProfileActivity extends BaseActivity implements OnLoadDataListener {

    private List<String> mListMenuNames;
    private UserModel mUser;

    private TextView mTvUsername;
    private ImageView mIvUserPhoto;

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
        mListMenuNames.add(getString(R.string.term_of_service));
        mListMenuNames.add(getString(R.string.privacy_policy));
        mListMenuNames.add(getString(R.string.specific_trade));
        mListMenuNames.add(getString(R.string.contact_us));
        mListMenuNames.add(getString(R.string.post_hope_of_shop_like));
        mListMenuNames.add(getString(R.string.logout));

        String token = CommonUtils.getToken(mContext);

        if(!token.equalsIgnoreCase("")) {
            new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
        } else {
            new DialogUtiils().showDialog(mContext, getString(R.string.need_login), true);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        mUser = CommonUtils.getProfile(mContext);
        popularUI();
    }

    private void initLayout()
    {
        activeProfile();

        mTvUsername = (TextView)findViewById(R.id.tv_user_name);
        mIvUserPhoto = (ImageView)findViewById(R.id.iv_user_pic);

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
                Intent profile = new Intent(mContext, ProfileEditActivity.class);
                profile.putExtra(Constants.EXTRA_USER, mUser);
                mContext.startActivity(profile);
            }
        });

        RelativeLayout rlShopFollow = (RelativeLayout)findViewById(R.id.rl_shop_follow);
        rlShopFollow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, ProfileShopFollowingActivity.class, false);
            }
        });

        RelativeLayout rlHistory = (RelativeLayout)findViewById(R.id.rl_history);
        rlHistory.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, ProfileHistoryActivity.class, false);
            }
        });

        RelativeLayout rlCouponsUsed = (RelativeLayout)findViewById(R.id.rl_news);
        rlCouponsUsed.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(mContext, NewsActivity.class, false);
            }
        });
    }

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(mContext, "");
                        checkToUpdateButtonLogin();
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
                    } else if (res.httpCode == APIConstants.HTTP_OK && res.code == APIConstants.REQUEST_OK) {
                        new UserProfileAPIHelper().getProfile(mContext, mHanlderGetProfile);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), true);
                    break;
            }
        }
    };

    private Handler mHanlderGetProfile = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:

                    ResponseProfileData profile = (ResponseProfileData) msg.obj;
                    if (profile.code == APIConstants.REQUEST_OK && profile.httpCode == APIConstants.HTTP_OK) {
                        mUser = profile.data;
                        popularUI();
                        CommonUtils.saveProfile(mContext, mUser);
                    } else if(profile.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
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

    private void popularUI()
    {
        if(mUser.getmUsername() != null) {
            mTvUsername.setText(mUser.getmUsername());
        }
//        if (mUser.getmName() != null && !mUser.getmName().equalsIgnoreCase("")) {
//            mTvUsername.setText(mUser.getmName());
//        } else if(mUser.getmUsername() != null) {
//            mTvUsername.setText(mUser.getmUsername());
//        }
        if(mUser.getmAvatarUrl() != null && !mUser.getmAvatarUrl().equalsIgnoreCase("")) {
            Picasso p = Picasso.with(mContext);
            p.invalidate(mUser.getmAvatarUrl());
            p.load(mUser.getmAvatarUrl())
                    .fit()
                    .noFade()
                    .centerCrop()
                    .placeholder(R.drawable.ic_avarta_user)
                    .into(mIvUserPhoto);
        }
    }
}
