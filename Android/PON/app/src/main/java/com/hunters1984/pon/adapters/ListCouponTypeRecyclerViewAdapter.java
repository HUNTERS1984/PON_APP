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
import com.hunters1984.pon.activities.ShopCouponFilterActivity;
import com.hunters1984.pon.models.CouponTypeModel;
import com.hunters1984.pon.utils.CommonUtils;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class ListCouponTypeRecyclerViewAdapter extends RecyclerView.Adapter<ListCouponTypeRecyclerViewAdapter.ListCouponTypeRecyclerViewHolders> {

    private List<CouponTypeModel> mLstCouponTypes;
    private Context mContext;

    public ListCouponTypeRecyclerViewAdapter(Context context, List<CouponTypeModel> lstCouponTypes) {
        this.mLstCouponTypes = lstCouponTypes;
        this.mContext = context;
    }

    @Override
    public ListCouponTypeRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.coupon_type_item, null);
        ListCouponTypeRecyclerViewHolders holders = new ListCouponTypeRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(ListCouponTypeRecyclerViewHolders holder, int position) {
        CouponTypeModel couponType = mLstCouponTypes.get(position);
        holder.mCouponTypeName.setText(couponType.getmName());
        Picasso.with(mContext).load(couponType.getmIcon()).
                resize(CommonUtils.dpToPx(mContext, 20), CommonUtils.dpToPx(mContext, 20))
                .into(holder.mCouponTypeIcon);
    }

    @Override
    public int getItemCount() {
        return this.mLstCouponTypes.size();
    }

    public class ListCouponTypeRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mCouponTypeIcon;
        public TextView mCouponTypeName;

        public ListCouponTypeRecyclerViewHolders(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            mCouponTypeIcon = (ImageView) itemView.findViewById(R.id.iv_coupon_type_icon);
            mCouponTypeName = (TextView) itemView.findViewById(R.id.tv_coupon_type_name);
        }

        @Override
        public void onClick(View view) {
            Intent iShopCouponsFilter = new Intent(mContext, ShopCouponFilterActivity.class);
            mContext.startActivity(iShopCouponsFilter);
        }
    }
}
