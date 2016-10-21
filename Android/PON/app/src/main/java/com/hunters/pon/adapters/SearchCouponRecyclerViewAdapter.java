package com.hunters.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.CouponDetailActivity;
import com.hunters.pon.api.ResponseCouponDetail;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoginClickListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class SearchCouponRecyclerViewAdapter extends RecyclerView.Adapter<SearchCouponRecyclerViewAdapter.SearchCouponRecyclerViewHolders> {

    private List<ResponseCouponDetail> mListCoupons;
    private Context mContext;
    private OnLoginClickListener mLoginClick;

    public SearchCouponRecyclerViewAdapter(Context context, List<ResponseCouponDetail> lstCoupons, OnLoginClickListener loginClick) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
        mLoginClick = loginClick;
    }

    public SearchCouponRecyclerViewAdapter(Context context, List<ResponseCouponDetail> lstCoupons) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
    }

    @Override
    public SearchCouponRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.search_coupon_item, null);
        SearchCouponRecyclerViewHolders holders = new SearchCouponRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(final SearchCouponRecyclerViewHolders holder, int position) {
        ResponseCouponDetail coupon = mListCoupons.get(position);
        holder.mShopName.setText(coupon.getmShop().getmShopName());
        holder.mCouponTitle.setText(coupon.getmTitle());
        holder.mCouponDescription.setText(coupon.getmCouponType().getmName());
        holder.mCouponExpireDate.setText(mContext.getString(R.string.deadline) + CommonUtils.convertDateFormat(coupon.getmExpireDate()));
        Picasso.with(mContext).load(coupon.getmImageUrl()).placeholder(R.color.light_grey_stroke_icon).
                fit().centerCrop().
                into(holder.mCouponPhoto,  new Callback() {

                    @Override
                    public void onSuccess() {
                        holder.mProgressBarLoadingCoupon.setVisibility(View.INVISIBLE);
                    }

                    @Override
                    public void onError() {
                        holder.mProgressBarLoadingCoupon.setVisibility(View.VISIBLE);
                    }
                });
//        holder.mCouponPhoto.setBackgroundColor(ContextCompat.getColor(mContext, R.color.light_grey_stroke_icon));

        if(coupon.ismIsUsed()) {
            holder.mIconUseCoupon.setVisibility(View.VISIBLE);
        } else {
            holder.mIconUseCoupon.setVisibility(View.GONE);
        }
        holder.mCouponIsFavourite.setImageResource(mListCoupons.get(position).getmIsFavourite()?R.drawable.ic_favourite:R.drawable.ic_non_favourite);
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons.size();
    }

    public void updateData(List<ResponseCouponDetail> lstCoupons)
    {
        mListCoupons = lstCoupons;
        notifyDataSetChanged();
    }

    public class SearchCouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mShopName;
        public TextView mCouponTitle;
        public TextView mCouponDescription;
        public TextView mCouponExpireDate;
        public ImageView mCouponPhoto, mCouponIsFavourite, mIconUseCoupon;
        public LinearLayout mLinearLoginRequired;
        public View mView;
        public ProgressBar mProgressBarLoadingCoupon;
        private Button mBtnLogin;

        public SearchCouponRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mShopName = (TextView)itemView.findViewById(R.id.tv_shop_name);
            mIconUseCoupon = (ImageView)itemView.findViewById(R.id.iv_use_coupon);
            mCouponTitle = (TextView)itemView.findViewById(R.id.tv_coupon_title);
            mCouponDescription = (TextView) itemView.findViewById(R.id.tv_coupon_description);
            mCouponExpireDate = (TextView) itemView.findViewById(R.id.tv_coupon_expire_date);
            mCouponPhoto = (ImageView) itemView.findViewById(R.id.iv_coupon_photo);
            mCouponIsFavourite = (ImageView) itemView.findViewById(R.id.iv_coupon_favourite);
            mLinearLoginRequired = (LinearLayout) itemView.findViewById(R.id.ln_login_required);
            mProgressBarLoadingCoupon = (ProgressBar) itemView.findViewById(R.id.progress_bar_loading_coupon);
            mBtnLogin = (Button)itemView.findViewById(R.id.btn_login) ;
            mBtnLogin.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (mLoginClick != null) {
                        mLoginClick.onLoginClick();
                    }
                }
            });
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            CouponModel coupon = mListCoupons.get(pos);
            boolean isLoginRequired = coupon.getmIsLoginRequired();
            if(isLoginRequired) {
                mLinearLoginRequired.setVisibility(View.VISIBLE);
            } else {
                mLinearLoginRequired.setVisibility(View.GONE);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, coupon.getmId());
                mContext.startActivity(iCouponDetail);
            }
        }
    }
}
