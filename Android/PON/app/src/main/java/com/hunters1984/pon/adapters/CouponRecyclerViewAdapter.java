package com.hunters1984.pon.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.models.CouponModel;

import java.util.List;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class CouponRecyclerViewAdapter extends RecyclerView.Adapter<CouponRecyclerViewAdapter.CouponRecyclerViewHolders> {

    private List<CouponModel> mListCoupons;
    private Context mContext;

    public CouponRecyclerViewAdapter(Context context, List<CouponModel> lstCoupons) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
    }

    @Override
    public CouponRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.card_coupon_item, null);
        CouponRecyclerViewHolders holders = new CouponRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(CouponRecyclerViewHolders holder, int position) {
        holder.mCouponTitle.setText(mListCoupons.get(position).getmTitle());
        holder.mCouponDescription.setText(mListCoupons.get(position).getmDescription());
        holder.mCouponExpireDate.setText(mListCoupons.get(position).getmExpireDate());
        holder.mCouponPhoto.setImageResource(R.drawable.coupon_example);
        holder.mCouponIsFavourite.setImageResource(mListCoupons.get(position).ismIsFavourite()?R.drawable.favourite:R.drawable.non_favourite);
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons.size();
    }

    public class CouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mCouponTitle;
        public TextView mCouponDescription;
        public TextView mCouponExpireDate;
        public ImageView mCouponPhoto;
        public ImageView mCouponIsFavourite;

        public CouponRecyclerViewHolders(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            mCouponTitle = (TextView)itemView.findViewById(R.id.tv_coupon_title);
            mCouponDescription = (TextView) itemView.findViewById(R.id.tv_coupon_description);
            mCouponExpireDate = (TextView) itemView.findViewById(R.id.tv_coupon_expire_date);
            mCouponPhoto = (ImageView) itemView.findViewById(R.id.iv_coupon_photo);
            mCouponIsFavourite = (ImageView) itemView.findViewById(R.id.iv_coupon_favourite);
        }

        @Override
        public void onClick(View view) {

        }
    }
}
