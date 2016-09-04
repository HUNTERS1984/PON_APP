package com.hunters1984.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.activities.ShopSubscribeDetailActivity;
import com.hunters1984.pon.models.ShopModel;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class ListShopRecyclerViewAdapter extends RecyclerView.Adapter<ListShopRecyclerViewAdapter.ListShopRecyclerViewHolders> {

    private List<ShopModel> mListShops;
    private Context mContext;
    private boolean mIsShopLocation;

    public ListShopRecyclerViewAdapter(Context context, List<ShopModel> lstShop, boolean isShopLocation) {
        this.mListShops = lstShop;
        this.mContext = context;
        this.mIsShopLocation = isShopLocation;
    }

    @Override
    public ListShopRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.shop_item, null);
        ListShopRecyclerViewHolders holders = new ListShopRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(ListShopRecyclerViewHolders holder, int position) {
        holder.mShopName.setText(mListShops.get(position).getmShopName());
        holder.mShopLogo.setImageResource(R.drawable.ico_location);
        if(mIsShopLocation) {
            holder.mNumberOfShopSubscribe.setVisibility(View.GONE);
        } else {
            holder.mNumberOfShopSubscribe.setVisibility(View.VISIBLE);
            holder.mNumberOfShopSubscribe.setText(mListShops.get(position).getmNumberOfShopSubscribe());
        }
    }

    @Override
    public int getItemCount() {
        return this.mListShops.size();
    }

    public class ListShopRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mShopLogo;
        public TextView mShopName;
        public TextView mNumberOfShopSubscribe;

        public ListShopRecyclerViewHolders(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            mShopLogo = (ImageView) itemView.findViewById(R.id.iv_shop_logo);
            mShopName = (TextView) itemView.findViewById(R.id.tv_shop_name);
            mNumberOfShopSubscribe = (TextView)itemView.findViewById(R.id.tv_num_of_shop_subscribe);
        }

        @Override
        public void onClick(View view) {
            Intent iShopsubscribeDetail = new Intent(mContext, ShopSubscribeDetailActivity.class);
            mContext.startActivity(iShopsubscribeDetail);
        }
    }
}
