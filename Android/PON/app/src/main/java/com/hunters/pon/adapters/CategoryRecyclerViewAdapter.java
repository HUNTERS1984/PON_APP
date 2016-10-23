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
import com.hunters.pon.activities.CouponByCategoryDetailActivity;
import com.hunters.pon.models.CategoryModel;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.viewholders.LoadingViewHolder;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class CategoryRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<CategoryModel> mLstCategories;
    private Context mContext;

    public CategoryRecyclerViewAdapter(Context context, List<CategoryModel> lstCategories) {
        this.mLstCategories = lstCategories;
        this.mContext = context;
    }

    @Override
    public int getItemViewType(int position) {
        return mLstCategories.get(position) == null ? Constants.VIEW_TYPE_LOADING : Constants.VIEW_TYPE_ITEM;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == Constants.VIEW_TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.category_item, null);
            CategoryRecyclerViewHolders holders = new CategoryRecyclerViewHolders(view);
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
        if (holder instanceof CategoryRecyclerViewHolders) {
            final CategoryRecyclerViewHolders categoryHolder = (CategoryRecyclerViewHolders) holder;
            CategoryModel couponType = mLstCategories.get(position);
            categoryHolder.mCategoryName.setText(couponType.getmName());
            Picasso.with(mContext).load(couponType.getmIcon()).
                    fit()
                    .into(categoryHolder.mCategoryIcon);
            categoryHolder.mView.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mLstCategories == null ? 0 : this.mLstCategories.size();
    }

    public void updateData(List<CategoryModel> lstCategories) {
        mLstCategories = lstCategories;
        notifyDataSetChanged();
    }

    public class CategoryRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public ImageView mCategoryIcon;
        public TextView mCategoryName;
        public View mView;

        public CategoryRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mCategoryIcon = (ImageView) itemView.findViewById(R.id.iv_coupon_type_icon);
            mCategoryName = (TextView) itemView.findViewById(R.id.tv_coupon_type_name);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            CategoryModel cat = mLstCategories.get(pos);
            Intent iCouponByCategory = new Intent(mContext, CouponByCategoryDetailActivity.class);
            iCouponByCategory.putExtra(Constants.EXTRA_COUPON_TYPE_ID, cat.getmId());
            iCouponByCategory.putExtra(Constants.EXTRA_TITLE, cat.getmName());
            mContext.startActivity(iCouponByCategory);
        }
    }
}
