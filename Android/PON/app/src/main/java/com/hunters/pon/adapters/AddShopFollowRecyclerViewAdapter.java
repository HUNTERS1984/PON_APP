package com.hunters.pon.adapters;

import android.app.Activity;
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

import com.hunters.pon.R;
import com.hunters.pon.activities.ShopDetailActivity;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.models.ShopModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.viewholders.LoadingViewHolder;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/4/2016.
 */
public class AddShopFollowRecyclerViewAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<ShopModel> mLstShopFollows;
    private Context mContext;

    public AddShopFollowRecyclerViewAdapter(Context context, List<ShopModel> lstShopFollows) {
        this.mLstShopFollows = lstShopFollows;
        this.mContext = context;
    }

    @Override
    public int getItemViewType(int position) {
        return mLstShopFollows.get(position) == null ? Constants.VIEW_TYPE_LOADING : Constants.VIEW_TYPE_ITEM;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        if (viewType == Constants.VIEW_TYPE_ITEM) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.shop_follow_detail_item, null);
            ShopFollowDetailRecyclerViewHolders holders = new ShopFollowDetailRecyclerViewHolders(view);
            return holders;
        } else if (viewType == Constants.VIEW_TYPE_LOADING) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.loading_item_layout, parent, false);
            LoadingViewHolder holders = new LoadingViewHolder(view);
            return holders;
        }
        return null;
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, int position) {
        if (holder instanceof ShopFollowDetailRecyclerViewHolders) {
            final ShopFollowDetailRecyclerViewHolders shopHolder = (ShopFollowDetailRecyclerViewHolders)holder;
            ShopModel shop = mLstShopFollows.get(position);
            Picasso.with(mContext).load(shop.getmShopPhotoAvarta())
                    .fit().centerCrop()
                    .into(shopHolder.mShopPhoto, new Callback() {
                        @Override
                        public void onSuccess() {
                            shopHolder.mProgressBarLoadingShopPhoto.setVisibility(View.GONE);
                        }

                        @Override
                        public void onError() {
                            shopHolder.mProgressBarLoadingShopPhoto.setVisibility(View.VISIBLE);
                        }
                    });

            boolean isShopFollow = shop.getmIsShopFollow();
            if (isShopFollow) {
                shopHolder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_highlight);
                shopHolder.mDesShopSelectStatus.setText(mContext.getString(R.string.following));
                shopHolder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.white));
                shopHolder.mIconShopSelectStatus.setImageResource(R.drawable.ic_tick);
            } else {
                shopHolder.mBackgroundShopSelectStatus.setBackgroundResource(R.drawable.background_rectangle_non_highlight);
                shopHolder.mDesShopSelectStatus.setText(mContext.getString(R.string.follow));
                shopHolder.mDesShopSelectStatus.setTextColor(ContextCompat.getColor(mContext, R.color.shop_subscribe_select));
                shopHolder.mIconShopSelectStatus.setImageResource(R.drawable.ic_add_follow_shop);
            }
            shopHolder.mBackgroundShopSelectStatus.setTag(position);
            shopHolder.mView.setTag(position);
        } else if (holder instanceof LoadingViewHolder) {
            LoadingViewHolder loadingViewHolder = (LoadingViewHolder) holder;
            loadingViewHolder.mProgressBar.setIndeterminate(true);
        }
    }

    @Override
    public int getItemCount() {
        return this.mLstShopFollows == null ? 0 : this.mLstShopFollows.size();
    }

    public void updateData(List<ShopModel> lstShopFollows)
    {
        mLstShopFollows = lstShopFollows;
        notifyDataSetChanged();
    }

    public class ShopFollowDetailRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public View mView;
        public ImageView mShopPhoto;
        public RelativeLayout mBackgroundShopSelectStatus;
        public TextView mDesShopSelectStatus;
        public ImageView mIconShopSelectStatus;
        public ProgressBar mProgressBarLoadingShopPhoto;

        private int mPosSelection;

        public ShopFollowDetailRecyclerViewHolders(View itemView) {
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
            long shopId = shop.getmId();
            switch (view.getId()){
                case R.id.rl_back_ground_shop_select_status:
                    String token = CommonUtils.getToken(mContext);
                    if(token.equalsIgnoreCase("")) {
                        ExtraDataModel extra = new ExtraDataModel();
                        extra.setmTitle(Constants.EXTRA_FOLLOW_SHOP);
                        extra.setmId(shopId);
                        extra.setmArg(mPosSelection);
                        new DialogUtiils().showDialogLogin((Activity)mContext, mContext.getString(R.string.need_login), extra );
                    } else {
                        new ShopAPIHelper().addShopFollow(mContext, shopId, mHanlderAddShopFollow);
                    }
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
                            boolean isShopFollow = shop.getmIsShopFollow();
                            mLstShopFollows.get(mPosSelection).setmIsShopFollow(!isShopFollow);
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
