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
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class CouponTypeShopFollowRecyclerViewAdapter extends RecyclerView.Adapter<CouponTypeShopFollowRecyclerViewAdapter.ListCouponTypeRecyclerViewHolders> {

    private List<CategoryShopFollowModel> mLstCouponTypeShopFollows;
    private Context mContext;

    public CouponTypeShopFollowRecyclerViewAdapter(Context context, List<CategoryShopFollowModel> lstCouponTypeShopFollows) {
        this.mLstCouponTypeShopFollows = lstCouponTypeShopFollows;
        this.mContext = context;
    }

    @Override
    public ListCouponTypeRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.coupons_type_shop_follow_item, null);
        ListCouponTypeRecyclerViewHolders holders = new ListCouponTypeRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(ListCouponTypeRecyclerViewHolders holder, int position) {
        CategoryShopFollowModel couponTypeShopFollow = mLstCouponTypeShopFollows.get(position);
        holder.mCouponTypeName.setText(couponTypeShopFollow.getmCouponTypeName());
        Picasso.with(mContext).load(couponTypeShopFollow.getmCouponTypeIconUrl()).
                fit()
                .into(holder.mCouponTypeIcon);

        holder.mNumberOfShopFollow.setText(mLstCouponTypeShopFollows.get(position).getmShopBelongCount());
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mLstCouponTypeShopFollows.size();
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
