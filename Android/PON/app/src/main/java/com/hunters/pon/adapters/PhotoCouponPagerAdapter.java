package com.hunters.pon.adapters;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.hunters.pon.R;
import com.hunters.pon.utils.CommonUtils;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/12/2016.
 */
public class PhotoCouponPagerAdapter extends PagerAdapter {

    //    private List<String> mListProducts;
    private Context mContext;
    private LayoutInflater mLayoutInflater;
    private List<String> mListUserPhotos;

    public PhotoCouponPagerAdapter(Context context, List<String> lstProductPhotos){
        mContext = context;
        mListUserPhotos = lstProductPhotos;
        mLayoutInflater  = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return mListUserPhotos.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((RelativeLayout) object);
    }

    public void updatePhotos(List<String> lstPhotos)
    {
        mListUserPhotos = lstPhotos;
        notifyDataSetChanged();
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View itemView = mLayoutInflater.inflate(R.layout.coupon_photo_pager_item, container, false);

        ImageView imageView = (ImageView) itemView.findViewById(R.id.iv_photo);
        final ProgressBar progressBarLoadingPhoto = (ProgressBar) itemView.findViewById(R.id.progress_bar_loading_photo);

        String photo = mListUserPhotos.get(position);

        Picasso.with(mContext).load(photo).placeholder(R.color.color_background_pager_coupons).
                resize(CommonUtils.dpToPx(mContext, 250),CommonUtils.dpToPx(mContext, 180)).centerCrop().into(imageView, new Callback() {
            @Override
            public void onSuccess() {
                progressBarLoadingPhoto.setVisibility(View.GONE);
            }

            @Override
            public void onError() {
                progressBarLoadingPhoto.setVisibility(View.VISIBLE);
            }
        });


        container.addView(itemView);

        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((RelativeLayout) object);
    }
}
