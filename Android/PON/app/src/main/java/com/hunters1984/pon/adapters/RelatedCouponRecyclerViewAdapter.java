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
 * Created by LENOVO on 9/11/2016.
 */
public class RelatedCouponRecyclerViewAdapter extends RecyclerView.Adapter<RelatedCouponRecyclerViewAdapter.RelatedCouponRecyclerViewHolders> {

    private List<CouponModel> mListCoupons;
    private Context mContext;

    public RelatedCouponRecyclerViewAdapter(Context context, List<CouponModel> lstCoupons) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
    }

    @Override
    public RelatedCouponRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.related_coupon_item, null);
        RelatedCouponRecyclerViewHolders holders = new RelatedCouponRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(RelatedCouponRecyclerViewHolders holder, int position) {
        if(position != (mListCoupons.size() - 1)) {
            holder.mCouponPhoto.setImageResource(R.drawable.coupon_example);
            holder.mCouponPhoto.setVisibility(View.VISIBLE);
            holder.mViewMore.setVisibility(View.INVISIBLE);
        } else {
            holder.mCouponPhoto.setVisibility(View.INVISIBLE);
            holder.mViewMore.setVisibility(View.VISIBLE);
        }
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons.size();
    }

    public class RelatedCouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mCouponPhoto;
        public TextView mViewMore;
        public View mView;

        public RelatedCouponRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mCouponPhoto = (ImageView) itemView.findViewById(R.id.iv_related_coupons);
            mViewMore = (TextView) itemView.findViewById(R.id.tv_view_more);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());

        }
    }
}
