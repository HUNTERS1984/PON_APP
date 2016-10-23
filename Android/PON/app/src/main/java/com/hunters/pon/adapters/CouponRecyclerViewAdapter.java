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
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoginClickListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.viewholders.LoadingViewHolder;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class CouponRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<CouponModel> mListCoupons;
    private Context mContext;
    private OnLoginClickListener mLoginClick;

    public CouponRecyclerViewAdapter(Context context, List<CouponModel> lstCoupons, OnLoginClickListener loginClick) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
        mLoginClick = loginClick;
    }

    public CouponRecyclerViewAdapter(Context context, List<CouponModel> lstCoupons) {
        this.mListCoupons = lstCoupons;
        this.mContext = context;
    }

    @Override
    public int getItemViewType(int position) {
        return mListCoupons.get(position) == null ? Constants.VIEW_TYPE_LOADING : Constants.VIEW_TYPE_ITEM;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == Constants.VIEW_TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.card_coupon_item, null);
            CouponRecyclerViewHolders holders = new CouponRecyclerViewHolders(view);
            return holders;
        }  else if (viewType == Constants.VIEW_TYPE_LOADING) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.loading_item_layout, parent, false);
            LoadingViewHolder holders = new LoadingViewHolder(view);
            return holders;
        }
        return null;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof CouponRecyclerViewHolders) {
            final CouponRecyclerViewHolders couponHolder = (CouponRecyclerViewHolders)holder;
            CouponModel coupon = mListCoupons.get(position);
            couponHolder.mCouponTitle.setText(coupon.getmTitle());
            couponHolder.mCouponDescription.setText(coupon.getmCouponType().getmName());
            couponHolder.mCouponExpireDate.setText(mContext.getString(R.string.deadline) + CommonUtils.convertDateFormat(coupon.getmExpireDate()));
            Picasso.with(mContext).load(coupon.getmImageUrl()).placeholder(R.color.light_grey_stroke_icon).
                    fit().centerCrop().
                    into(couponHolder.mCouponPhoto, new Callback() {

                        @Override
                        public void onSuccess() {
                            couponHolder.mProgressBarLoadingCoupon.setVisibility(View.INVISIBLE);
                        }

                        @Override
                        public void onError() {
                            couponHolder.mProgressBarLoadingCoupon.setVisibility(View.VISIBLE);
                        }
                    });
//        holder.mCouponPhoto.setBackgroundColor(ContextCompat.getColor(mContext, R.color.light_grey_stroke_icon));

            if (coupon.ismIsUsed()) {
                couponHolder.mIconUseCoupon.setVisibility(View.VISIBLE);
            } else {
                couponHolder.mIconUseCoupon.setVisibility(View.GONE);
            }
            couponHolder.mCouponIsFavourite.setImageResource(mListCoupons.get(position).getmIsFavourite() ? R.drawable.ic_favourite : R.drawable.ic_non_favourite);
            couponHolder.mView.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons == null ? 0 :this.mListCoupons.size();
    }

    public void updateData(List<CouponModel> lstCoupons)
    {
        mListCoupons = lstCoupons;
        notifyDataSetChanged();
    }

    public class CouponRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mCouponTitle;
        public TextView mCouponDescription;
        public TextView mCouponExpireDate;
        public ImageView mCouponPhoto, mCouponIsFavourite, mIconUseCoupon;
        public LinearLayout mLinearLoginRequired;
        public View mView;
        public ProgressBar mProgressBarLoadingCoupon;
        private Button mBtnLogin;

        public CouponRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
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
