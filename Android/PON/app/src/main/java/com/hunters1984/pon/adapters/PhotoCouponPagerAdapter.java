package com.hunters1984.pon.adapters;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.hunters1984.pon.R;

/**
 * Created by LENOVO on 9/12/2016.
 */
public class PhotoCouponPagerAdapter extends PagerAdapter {

    //    private List<String> mListProducts;
    private Context mContext;
    private LayoutInflater mLayoutInflater;
    private int[] mListCouponPhotos;

    public PhotoCouponPagerAdapter(Context context, int[] lstProductPhotos){
        mContext = context;
//        this.mListCouponPhotos = new ArrayList<>();
//        this.mListCouponPhotos.addAll(lstProductPhotos);
        mListCouponPhotos = lstProductPhotos;
        mLayoutInflater  = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return mListCouponPhotos.length;//mListProducts.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((LinearLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View itemView = mLayoutInflater.inflate(R.layout.coupon_photo_pager_item, container, false);

        ImageView imageView = (ImageView) itemView.findViewById(R.id.iv_photo);
        imageView.setBackgroundColor(ContextCompat.getColor(mContext, mListCouponPhotos[position]));
//        if (mSourceToLoadImage == Constants.LOAD_IMAGE_FROM_URL) {
//            if (!mListProductPhotos.get(position).equalsIgnoreCase("")) {
//                Picasso.with(mContext).load(mListProductPhotos.get(position)).into(imageView);
//            }
//        } else {
//            Integer resId = Integer.parseInt(mListProductPhotos.get(position));
//            imageView.setImageResource(resId);
//        }

        container.addView(itemView);

        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((LinearLayout) object);
    }
}
