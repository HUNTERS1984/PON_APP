package com.hunters1984.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.activities.ShopDetailActivity;
import com.hunters1984.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class ShopSubscribeDetailRecyclerViewAdapter extends RecyclerView.Adapter<ShopSubscribeDetailRecyclerViewAdapter.ShopSubscribeDetailRecyclerViewHolders> {

    private List<ShopModel> mListShops;
    private Context mContext;

    public ShopSubscribeDetailRecyclerViewAdapter(Context context, List<ShopModel> lstShop) {
        this.mListShops = lstShop;
        this.mContext = context;
    }

    @Override
    public ShopSubscribeDetailRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.shop_subscribe_detail_item, null);
        ShopSubscribeDetailRecyclerViewHolders holders = new ShopSubscribeDetailRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(ShopSubscribeDetailRecyclerViewHolders holder, int position) {
        boolean isShopSubscribe = mListShops.get(position).ismIsShopSubscribe();
        if(isShopSubscribe){
            holder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_highlight);
            holder.mDesShopSelectStatus.setText(mContext.getString(R.string.following));
            holder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.white));
            holder.mIconShopSelectStatus.setImageResource(R.drawable.ic_tick);

        } else {
            holder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_non_highlight);
            holder.mDesShopSelectStatus.setText(mContext.getString(R.string.follow));
            holder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.shop_subscribe_select));
            holder.mIconShopSelectStatus.setImageResource(R.drawable.ic_add_follow_shop);
        }
        holder.mBackgroundShopSelectStatus.setTag(position);
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListShops.size();
    }

    public class ShopSubscribeDetailRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public View mView;
        public ImageView mShopPhoto;
        public RelativeLayout mBackgroundShopSelectStatus;
        public TextView mDesShopSelectStatus;
        public ImageView mIconShopSelectStatus;

        public ShopSubscribeDetailRecyclerViewHolders(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            mView = itemView;
            mBackgroundShopSelectStatus = (RelativeLayout) itemView.findViewById(R.id.rl_back_ground_shop_select_status);
            mShopPhoto = (ImageView) itemView.findViewById(R.id.iv_shop_photo);
            mDesShopSelectStatus = (TextView) itemView.findViewById(R.id.tv_shop_select_status);
            mIconShopSelectStatus = (ImageView) itemView.findViewById(R.id.iv_shop_select_status);

            mBackgroundShopSelectStatus.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());

            switch (view.getId()){
                case R.id.rl_back_ground_shop_select_status:
                    boolean isShopSubscribe = mListShops.get(pos).ismIsShopSubscribe();
                    mListShops.get(pos).setmIsShopSubscribe(!isShopSubscribe);
                    notifyDataSetChanged();
                    break;
                default:
                    mContext.startActivity(new Intent(mContext, ShopDetailActivity.class));
                    break;
            }

        }
    }
}
