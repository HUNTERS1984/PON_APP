package com.hunters.pon.adapters;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.login.LoginManager;
import com.hunters.pon.R;
import com.hunters.pon.activities.ChangePasswordActivity;
import com.hunters.pon.activities.PrivacyPolicyActivity;
import com.hunters.pon.activities.SpecificTradeActivity;
import com.hunters.pon.activities.SplashActivity;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class ProfileMenuRecyclerViewAdapter extends RecyclerView.Adapter<ProfileMenuRecyclerViewAdapter.ProfileMenuRecyclerViewHolders> {

    private List<String> mListMenuItems;
    private Context mContext;

    public ProfileMenuRecyclerViewAdapter(Context context, List<String> lstMenuItems) {
        this.mListMenuItems = lstMenuItems;
        this.mContext = context;
    }

    @Override
    public ProfileMenuRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.profile_menu_item, null);
        ProfileMenuRecyclerViewHolders holders = new ProfileMenuRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(ProfileMenuRecyclerViewHolders holder, int position) {
        holder.mMenuName.setText(mListMenuItems.get(position));
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListMenuItems.size();
    }

    public class ProfileMenuRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mMenuName;
        public View mView;

        public ProfileMenuRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mMenuName = (TextView) itemView.findViewById(R.id.tv_menu_name);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            switch (pos)
            {
                case 0:
                    break;
                case 1:
                    mContext.startActivity(new Intent(mContext, PrivacyPolicyActivity.class));
                    break;
                case 2:
                    mContext.startActivity(new Intent(mContext, SpecificTradeActivity.class));
                    break;
                case 5://Change password if login type is email or Logout:
                    int loginType = CommonUtils.getLogintype(mContext);
                    if(loginType == Constants.LOGIN_EMAIL) {
                        mContext.startActivity(new Intent(mContext, ChangePasswordActivity.class));
                    } else {
                        new UserProfileAPIHelper().signOut(mContext, mHanlderSignOut);
                    }
                    break;
                case 6://Logout
                    new UserProfileAPIHelper().signOut(mContext, mHanlderSignOut);
                    break;
            }
        }

        private Handler mHanlderSignOut = new Handler(){
            @Override
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                        ResponseCommon user = (ResponseCommon) msg.obj;
                        if (user.code == APIConstants.REQUEST_OK && user.httpCode == APIConstants.HTTP_OK) {
                            Intent iLogout = new Intent(mContext, SplashActivity.class);
                            iLogout.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                            mContext.startActivity(iLogout);
                            CommonUtils.saveToken(mContext, "");
                            LoginManager.getInstance().logOut();
                            ((Activity)mContext).finish();
                        } else {
                            new DialogUtiils().showDialog(mContext, user.message, false);
                        }
                        break;
                    case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                        new DialogUtiils().showDialog(mContext, mContext.getString(R.string.connection_failed), false);
                        break;
                }
            }
        };
    }
}
