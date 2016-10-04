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
import com.hunters1984.pon.activities.CouponByCategoryDetailActivity;
import com.hunters1984.pon.models.CategoryModel;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class CategoryRecyclerViewAdapter extends RecyclerView.Adapter<CategoryRecyclerViewAdapter.CategoryRecyclerViewHolders> {

    private List<CategoryModel> mLstCategories;
    private Context mContext;

    public CategoryRecyclerViewAdapter(Context context, List<CategoryModel> lstCategories) {
        this.mLstCategories = lstCategories;
        this.mContext = context;
    }

    @Override
    public CategoryRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.category_item, null);
        CategoryRecyclerViewHolders holders = new CategoryRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(CategoryRecyclerViewHolders holder, int position) {
        CategoryModel couponType = mLstCategories.get(position);
        holder.mCategoryName.setText(couponType.getmName());
        Picasso.with(mContext).load(couponType.getmIcon()).
                resize(CommonUtils.dpToPx(mContext, 20), CommonUtils.dpToPx(mContext, 20))
                .into(holder.mCategoryIcon);
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mLstCategories.size();
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
            Intent iCouponByCategory = new Intent(mContext, CouponByCategoryDetailActivity.class);
            iCouponByCategory.putExtra(Constants.EXTRA_COUPON_TYPE_ID, mLstCategories.get(pos).getmId());
            mContext.startActivity(iCouponByCategory);
        }
    }
}
