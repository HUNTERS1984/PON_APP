package com.hunters1984.pon.activities;

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

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ProfileMenuRecyclerViewAdapter;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.ResponseCommon;
import com.hunters1984.pon.api.ResponseProfileData;
import com.hunters1984.pon.api.UserProfileAPIHelper;
import com.hunters1984.pon.models.UserModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.hunters1984.pon.utils.DialogUtiils;
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

        String token = CommonUtils.getToken(mContext);

        if(!token.equalsIgnoreCase("")) {
            new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
        }
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
                        mTvUsername.setText(mUser.getmUsername());
                        if(mUser.getmAvatarUrl() != null) {
                            Picasso.with(mContext).load(mUser.getmAvatarUrl())
                                    .resize(CommonUtils.dpToPx(mContext, 90), CommonUtils.dpToPx(mContext, 90))
                                    .into(mIvUserPhoto);
                        }
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
}
