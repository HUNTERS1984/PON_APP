package com.hunters.ponstaff.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hunters.ponstaff.R;
import com.hunters.ponstaff.api.ResponseCouponRequest;
import com.hunters.ponstaff.customs.RequestCouponDialog;
import com.hunters.ponstaff.utils.Constants;
import com.hunters.ponstaff.viewholders.LoadingViewHolder;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class CouponRequestRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<ResponseCouponRequest> mLstCouponRequests;
    private Context mContext;

    public CouponRequestRecyclerViewAdapter(Context context, List<ResponseCouponRequest> lstCouponRequests) {
        this.mLstCouponRequests = lstCouponRequests;
        this.mContext = context;
    }

    @Override
    public int getItemViewType(int position) {
        return mLstCouponRequests.get(position) == null ? Constants.VIEW_TYPE_LOADING : Constants.VIEW_TYPE_ITEM;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == Constants.VIEW_TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.coupon_request_item, null);
            CouponRequestRecyclerViewHolders holders = new CouponRequestRecyclerViewHolders(view);
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
        if (holder instanceof CouponRequestRecyclerViewHolders) {
            final CouponRequestRecyclerViewHolders requestHolder = (CouponRequestRecyclerViewHolders) holder;
            ResponseCouponRequest request = mLstCouponRequests.get(position);
            requestHolder.mTitle.setText(request.getmUser().get(0).getmUsername());
            requestHolder.mDescription.setText(request.getmTitle());
            requestHolder.mTimeRequest.setText(request.getmExpireDate());

            requestHolder.mView.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mLstCouponRequests == null ? 0 : this.mLstCouponRequests.size();
    }

    public void updateData(List<ResponseCouponRequest> lstCouponRequests) {
        mLstCouponRequests = lstCouponRequests;
        notifyDataSetChanged();
    }

    public class CouponRequestRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mTitle, mDescription, mTimeRequest;
        public View mView;

        public CouponRequestRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mTitle = (TextView) itemView.findViewById(R.id.tv_request_coupon_title);
            mDescription = (TextView) itemView.findViewById(R.id.tv_request_coupon_description);
            mTimeRequest = (TextView) itemView.findViewById(R.id.tv_request_coupon_time);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            ResponseCouponRequest cat = mLstCouponRequests.get(pos);
            String couponId = String.valueOf(cat.getmId());
            String username = cat.getmUser().get(0).getmUsername();
            new RequestCouponDialog(mContext, couponId, username).show();
//            Intent iCouponByCategory = new Intent(mContext, CouponByCategoryDetailActivity.class);
//            iCouponByCategory.putExtra(Constants.EXTRA_COUPON_TYPE_ID, cat.getmId());
//            iCouponByCategory.putExtra(Constants.EXTRA_TITLE, cat.getmName());
//            mContext.startActivity(iCouponByCategory);
        }
    }
}
