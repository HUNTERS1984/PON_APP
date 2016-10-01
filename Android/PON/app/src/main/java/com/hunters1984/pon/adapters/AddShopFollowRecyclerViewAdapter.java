package com.hunters1984.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.activities.ShopDetailActivity;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.ResponseCommon;
import com.hunters1984.pon.api.ShopAPIHelper;
import com.hunters1984.pon.models.ShopModel;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.hunters1984.pon.utils.DialogUtiils;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class AddShopFollowRecyclerViewAdapter extends RecyclerView.Adapter<AddShopFollowRecyclerViewAdapter.ShopSubscribeDetailRecyclerViewHolders> {

    private List<ShopModel> mLstShopFollows;
    private Context mContext;

    public AddShopFollowRecyclerViewAdapter(Context context, List<ShopModel> lstShopFollows) {
        this.mLstShopFollows = lstShopFollows;
        this.mContext = context;
    }

    @Override
    public ShopSubscribeDetailRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.shop_follow_detail_item, null);
        ShopSubscribeDetailRecyclerViewHolders holders = new ShopSubscribeDetailRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(final ShopSubscribeDetailRecyclerViewHolders holder, int position) {
        ShopModel shop = mLstShopFollows.get(position);
        Picasso.with(mContext).load(shop.getmShopPhotoAvarta())
                .resize(CommonUtils.dpToPx(mContext, 150), CommonUtils.dpToPx(mContext, 150)).centerCrop()
                .into(holder.mShopPhoto, new Callback() {
                    @Override
                    public void onSuccess() {
                        holder.mProgressBarLoadingShopPhoto.setVisibility(View.GONE);
                    }

                    @Override
                    public void onError() {
                        holder.mProgressBarLoadingShopPhoto.setVisibility(View.VISIBLE);
                    }
                });

        boolean isShopFollow = CommonUtils.convertBoolean(shop.getmIsShopFollow());
        if(isShopFollow){
            holder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_highlight);
            holder.mDesShopSelectStatus.setText(mContext.getString(R.string.following));
            holder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.white));
            holder.mIconShopSelectStatus.setImageResource(R.drawable.ic_tick);
        } else {
            holder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_non_highlight);
            holder.mDesShopSelectStatus.setText(mContext.getString(R.string.follow));
            holder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.shop_subscribe_select));
            holder.mIconShopSelectStatus.setImageResource(R.drawable.ic_add_follow_shop);
        }
        holder.mBackgroundShopSelectStatus.setTag(position);
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mLstShopFollows.size();
    }

    public void updateData(List<ShopModel> lstShopFollows)
    {
        mLstShopFollows = lstShopFollows;
        notifyDataSetChanged();
    }

    public class ShopSubscribeDetailRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public View mView;
        public ImageView mShopPhoto;
        public RelativeLayout mBackgroundShopSelectStatus;
        public TextView mDesShopSelectStatus;
        public ImageView mIconShopSelectStatus;
        public ProgressBar mProgressBarLoadingShopPhoto;

        private int mPosSelection;

        public ShopSubscribeDetailRecyclerViewHolders(View itemView) {
            super(itemView);
            itemView.setOnClickListener(this);
            mView = itemView;
            mBackgroundShopSelectStatus = (RelativeLayout) itemView.findViewById(R.id.rl_back_ground_shop_select_status);
            mShopPhoto = (ImageView) itemView.findViewById(R.id.iv_shop_photo);
            mDesShopSelectStatus = (TextView) itemView.findViewById(R.id.tv_shop_select_status);
            mIconShopSelectStatus = (ImageView) itemView.findViewById(R.id.iv_shop_select_status);
            mProgressBarLoadingShopPhoto = (ProgressBar) itemView.findViewById(R.id.progress_bar_loading_shop_photo);

            mBackgroundShopSelectStatus.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            mPosSelection = Integer.parseInt(view.getTag().toString());
            ShopModel shop = mLstShopFollows.get(mPosSelection);
            double shopId = shop.getmId();
            switch (view.getId()){
                case R.id.rl_back_ground_shop_select_status:
                    new ShopAPIHelper().addShopFollow(mContext, shopId, mHanlderAddShopFollow);
//                    boolean isShopSubscribe = CommonUtils.convertBoolean(shop.getmIsShopFollow());
//                    mLstShopFollows.get(mPosSelection).setmIsShopFollow(CommonUtils.convertInt(!isShopSubscribe));
//                    notifyDataSetChanged();
                    break;
                default:
                    Intent shopDetail = new Intent(mContext, ShopDetailActivity.class);
                    shopDetail.putExtra(Constants.EXTRA_SHOP_ID, shopId);
                    mContext.startActivity(shopDetail);
                    break;
            }

        }

        protected Handler mHanlderAddShopFollow = new Handler(){
            @Override
            public void handleMessage(Message msg) {
                switch (msg.what) {
                    case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                        ResponseCommon shopFollow = (ResponseCommon) msg.obj;
                        if (shopFollow.code == APIConstants.REQUEST_OK && shopFollow.httpCode == APIConstants.HTTP_OK){
                            ShopModel shop = mLstShopFollows.get(mPosSelection);
                            boolean isShopSubscribe = CommonUtils.convertBoolean(shop.getmIsShopFollow());
                            mLstShopFollows.get(mPosSelection).setmIsShopFollow(CommonUtils.convertInt(!isShopSubscribe));
                            notifyDataSetChanged();
                        } else {
                            new DialogUtiils().showDialog(mContext, mContext.getString(R.string.token_expried), false);
                        }
                        break;
                    default:
                        new DialogUtiils().showDialog(mContext, mContext.getString(R.string.connection_failed), false);
                        break;
                }

            }
        };
    }
}
