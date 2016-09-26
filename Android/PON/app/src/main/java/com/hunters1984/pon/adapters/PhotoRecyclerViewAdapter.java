package com.hunters1984.pon.adapters;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters1984.pon.R;

import java.util.List;

/**
 * Created by LENOVO on 9/11/2016.
 */
public class PhotoRecyclerViewAdapter extends RecyclerView.Adapter<PhotoRecyclerViewAdapter.RelatedCouponRecyclerViewHolders> {

    private List<String> mListCoupons;
    private Context mContext;
    private boolean mIsShowMore;

    public PhotoRecyclerViewAdapter(Context context, List<String> lstPhotos, boolean isShowMore) {
        this.mListCoupons = lstPhotos;
        this.mContext = context;
        mIsShowMore = isShowMore;
    }

    @Override
    public RelatedCouponRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.photo_item, null);
        RelatedCouponRecyclerViewHolders holders = new RelatedCouponRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(RelatedCouponRecyclerViewHolders holder, int position) {
        if(mIsShowMore) {
            if (position != (mListCoupons.size() - 1)) {
                holder.mPhoto.setBackgroundColor(ContextCompat.getColor(mContext, R.color.light_grey_stroke_icon));
                holder.mPhoto.setVisibility(View.VISIBLE);
                holder.mViewMore.setVisibility(View.INVISIBLE);
            } else {
                holder.mPhoto.setVisibility(View.INVISIBLE);
                holder.mViewMore.setVisibility(View.VISIBLE);
            }
        } else {
            holder.mPhoto.setBackgroundColor(ContextCompat.getColor(mContext, R.color.grey));
            holder.mPhoto.setVisibility(View.VISIBLE);
            holder.mViewMore.setVisibility(View.GONE);
        }
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons.size();
    }

    public class RelatedCouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mPhoto;
        public TextView mViewMore;
        public View mView;

        public RelatedCouponRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mPhoto = (ImageView) itemView.findViewById(R.id.iv_photo);
            mViewMore = (TextView) itemView.findViewById(R.id.tv_view_more);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());

        }
    }
}
