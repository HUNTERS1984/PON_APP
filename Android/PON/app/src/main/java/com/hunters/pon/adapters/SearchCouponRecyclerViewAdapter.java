package com.hunters.pon.adapters;

import android.app.Activity;
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
import com.hunters.pon.activities.SplashActivity;
import com.hunters.pon.api.ResponseCouponDetail;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.viewholders.LoadingViewHolder;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/2/2016.
 */
public class SearchCouponRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<ResponseCouponDetail> mListCoupons;
    private Activity mContext;

    public SearchCouponRecyclerViewAdapter(Activity context, List<ResponseCouponDetail> lstCoupons) {
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
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.search_coupon_item, null);
            SearchCouponRecyclerViewHolders holders = new SearchCouponRecyclerViewHolders(view);
            return holders;
        } else if (viewType == Constants.VIEW_TYPE_LOADING) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.loading_item_layout, null);
            LoadingViewHolder holders = new LoadingViewHolder(view);
            return holders;
        }
        return null;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof SearchCouponRecyclerViewHolders) {
            final SearchCouponRecyclerViewHolders searchHolder = (SearchCouponRecyclerViewHolders) holder;
            ResponseCouponDetail coupon = mListCoupons.get(position);
            searchHolder.mShopName.setText(coupon.getmShop().getmShopName());
            searchHolder.mCouponTitle.setText(coupon.getmTitle());
            searchHolder.mCouponDescription.setText(coupon.getmCouponType().getmName());
            searchHolder.mCouponExpireDate.setText(mContext.getString(R.string.deadline) + CommonUtils.convertDateFormat(coupon.getmExpireDate()));
            Picasso.with(mContext).load(coupon.getmImageUrl()).placeholder(R.color.light_grey_stroke_icon).
                    fit().centerCrop().
                    into(searchHolder.mCouponPhoto, new Callback() {

                        @Override
                        public void onSuccess() {
                            searchHolder.mProgressBarLoadingCoupon.setVisibility(View.INVISIBLE);
                        }

                        @Override
                        public void onError() {
                            searchHolder.mProgressBarLoadingCoupon.setVisibility(View.VISIBLE);
                        }
                    });
//        holder.mCouponPhoto.setBackgroundColor(ContextCompat.getColor(mContext, R.color.light_grey_stroke_icon));

            if (coupon.ismIsUsed()) {
                searchHolder.mIconUseCoupon.setVisibility(View.VISIBLE);
            } else {
                searchHolder.mIconUseCoupon.setVisibility(View.GONE);
            }
            searchHolder.mCouponIsFavourite.setImageResource(mListCoupons.get(position).getmIsFavourite() ? R.drawable.ic_favourite : R.drawable.ic_non_favourite);
            searchHolder.mView.setTag(position);
            searchHolder.mBtnLogin.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mListCoupons == null ? 0 : this.mListCoupons.size();
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
//                    if (mLoginClick != null) {
//                        mLoginClick.onLoginClick();
//                    }
                    mLinearLoginRequired.setVisibility(View.GONE);
                    int pos = Integer.parseInt(view.getTag().toString());
                    CouponModel coupon = mListCoupons.get(pos);
                    Intent iLogin = new Intent(mContext, SplashActivity.class);
                    ExtraDataModel extraData = new ExtraDataModel();
                    extraData.setmId(coupon.getmId());
                    extraData.setmTitle(Constants.EXTRA_VIEW_COUPON_DETAIL);
                    iLogin.putExtra(Constants.EXTRA_DATA, extraData);
                    mContext.startActivityForResult(iLogin, Constants.REQUEST_CODE_COUPON_DETAIL);
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
