package com.hunters.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.PhotoActivity;
import com.hunters.pon.utils.Constants;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by LENOVO on 9/11/2016.
 */
public class PhotoRecyclerViewAdapter extends RecyclerView.Adapter<PhotoRecyclerViewAdapter.RelatedCouponRecyclerViewHolders> {

    private List<String> mLstVisiblePhotos, mLstPhotos;
    private Context mContext;
    private boolean mIsShowMore;
    private String mMorePhotoNumber;

    public PhotoRecyclerViewAdapter(Context context, List<String> lstVisiblePhotos, List<String> lstPhotos, boolean isShowMore) {
        this.mLstPhotos = lstPhotos;
        this.mLstVisiblePhotos = lstVisiblePhotos;
        this.mContext = context;
        mIsShowMore = isShowMore;
        mMorePhotoNumber = "";
    }

    @Override
    public RelatedCouponRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.photo_item, null);
        RelatedCouponRecyclerViewHolders holders = new RelatedCouponRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(final RelatedCouponRecyclerViewHolders holder, int position) {

        Picasso.with(mContext).load(mLstVisiblePhotos.get(position)).placeholder(R.color.grey).
                fit().centerCrop().
                into(holder.mPhoto, new Callback() {
            @Override
            public void onSuccess() {
                holder.mProgressBarLoadingCoupon.setVisibility(View.GONE);
            }

            @Override
            public void onError() {
                holder.mProgressBarLoadingCoupon.setVisibility(View.VISIBLE);
            }
        });

        if(mIsShowMore) {
            if (position != (mLstVisiblePhotos.size() - 1)) {
                holder.mPhoto.setVisibility(View.VISIBLE);
                holder.mTvMore.setVisibility(View.INVISIBLE);
            } else {
                holder.mTvMore.setText(mContext.getString(R.string.more).replace("%s", mMorePhotoNumber));
                holder.mPhoto.setVisibility(View.INVISIBLE);
                holder.mTvMore.setVisibility(View.VISIBLE);
                holder.mProgressBarLoadingCoupon.setVisibility(View.GONE);
            }
        } else {
            holder.mPhoto.setVisibility(View.VISIBLE);
            holder.mTvMore.setVisibility(View.GONE);
        }
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mLstVisiblePhotos.size();
    }

    public void updateData(List<String> lstVisiblePhotos, List<String> lstPhotos, boolean isShowMore, String moreNumber)
    {
        mLstVisiblePhotos = lstVisiblePhotos;
        mLstPhotos = lstPhotos;
        mIsShowMore = isShowMore;
        mMorePhotoNumber = moreNumber;
        notifyDataSetChanged();
    }

    public class RelatedCouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mPhoto;
        public TextView mTvMore;
        public View mView;
        public ProgressBar mProgressBarLoadingCoupon;

        public RelatedCouponRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
//            itemView.setOnClickListener(this);
            mPhoto = (ImageView) itemView.findViewById(R.id.iv_photo);
            mTvMore = (TextView) itemView.findViewById(R.id.tv_view_more);
            mProgressBarLoadingCoupon = (ProgressBar) itemView.findViewById(R.id.progress_bar_loading_coupon_photo);

            mTvMore.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(mLstPhotos != null) {
                        Intent iPhoto = new Intent(mContext, PhotoActivity.class);
                        iPhoto.putStringArrayListExtra(Constants.EXTRA_DATA, (ArrayList<String>) mLstPhotos);
                        mContext.startActivity(iPhoto);
                    }
                }
            });
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
        }
    }
}
