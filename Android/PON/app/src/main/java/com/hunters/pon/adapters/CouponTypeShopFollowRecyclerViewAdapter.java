package com.hunters.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.AddShopFollowDetailActivity;
import com.hunters.pon.models.CategoryShopFollowModel;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.viewholders.LoadingViewHolder;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class CouponTypeShopFollowRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<CategoryShopFollowModel> mLstCouponTypeShopFollows;
    private Context mContext;

    public CouponTypeShopFollowRecyclerViewAdapter(Context context, List<CategoryShopFollowModel> lstCouponTypeShopFollows) {
        this.mLstCouponTypeShopFollows = lstCouponTypeShopFollows;
        this.mContext = context;
    }

    @Override
    public int getItemViewType(int position) {
        return mLstCouponTypeShopFollows.get(position) == null ? Constants.VIEW_TYPE_LOADING : Constants.VIEW_TYPE_ITEM;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == Constants.VIEW_TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.coupons_type_shop_follow_item, null);
            ListCouponTypeRecyclerViewHolders holders = new ListCouponTypeRecyclerViewHolders(view);
            return holders;
        } else if (viewType == Constants.VIEW_TYPE_LOADING) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.loading_item_layout, parent, false);
            LoadingViewHolder holders = new LoadingViewHolder(view);
            return holders;
        }
        return null;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof ListCouponTypeRecyclerViewHolders) {
            ListCouponTypeRecyclerViewHolders couponTypeHolder = (ListCouponTypeRecyclerViewHolders)holder;
            CategoryShopFollowModel couponTypeShopFollow = mLstCouponTypeShopFollows.get(position);
            couponTypeHolder.mCouponTypeName.setText(couponTypeShopFollow.getmCouponTypeName());
            Picasso.with(mContext).load(couponTypeShopFollow.getmCouponTypeIconUrl()).
                    fit()
                    .into(couponTypeHolder.mCouponTypeIcon);

            couponTypeHolder.mNumberOfShopFollow.setText(mLstCouponTypeShopFollows.get(position).getmShopBelongCount());
            couponTypeHolder.mView.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mLstCouponTypeShopFollows == null ? 0 : this.mLstCouponTypeShopFollows.size();
    }

    public void updateData(List<CategoryShopFollowModel> lstCouponTypeShopFollows)
    {
        mLstCouponTypeShopFollows = lstCouponTypeShopFollows;
        notifyDataSetChanged();
    }

    public class ListCouponTypeRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mCouponTypeIcon;
        public TextView mCouponTypeName;
        public TextView mNumberOfShopFollow;
        public View mView;

        public ListCouponTypeRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mCouponTypeIcon = (ImageView) itemView.findViewById(R.id.iv_coupon_type_icon);
            mCouponTypeName = (TextView) itemView.findViewById(R.id.tv_coupon_type_name);
            mNumberOfShopFollow = (TextView)itemView.findViewById(R.id.tv_num_of_shop_follow);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            Intent iShopFollowDetail = new Intent(mContext, AddShopFollowDetailActivity.class);
            iShopFollowDetail.putExtra(Constants.EXTRA_COUPON_TYPE_ID, mLstCouponTypeShopFollows.get(pos).getmCouponTypeId());
            mContext.startActivity(iShopFollowDetail);
        }
    }
}
