package com.hunters1984.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.activities.PrivacyPolicyActivity;
import com.hunters1984.pon.activities.SpecificTradeActivity;

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
            }
        }
    }
}
