package com.hunters.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.PhotoCouponPagerAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseNewsDetailData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class NewsDetailActivity extends BaseActivity implements OnLoadDataListener {

    private TextView mTvNewsCat, mTvNewsTitle, mTvNewsDescription, mTvNewsDate;
    private long mId;
    private List<String> mLstNewsPhotos;

    private ViewPager mPagerNewsPhotos;
    private CirclePageIndicator mPageIndicatorNews;
    private PhotoCouponPagerAdapter mNewsPhotoPagerAdapter;
    private RelativeLayout mRlPhotos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        mId = getIntent().getLongExtra(Constants.EXTRA_ID, -1);
        setContentView(R.layout.activity_news_detail);
        super.onCreate(savedInstanceState);

        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.PROFILE_NEWS_DETAIL_SCREEN);
    }


    @Override
    public void onLoadData() {
        mLstNewsPhotos = new ArrayList<>();
        new UserProfileAPIHelper().getNewsDetail(mContext, mId, mHanlderGetNewsDetail);
    }

    private void initLayout()
    {
        setTitle("");

        mTvNewsCat = (TextView)findViewById(R.id.tv_news_cat);
        mTvNewsTitle = (TextView)findViewById(R.id.tv_news_title);
        mTvNewsDate = (TextView)findViewById(R.id.tv_news_date);
        mTvNewsDescription = (TextView)findViewById(R.id.tv_news_description);

        mRlPhotos = (RelativeLayout)findViewById(R.id.rl_news_photo);
        mPagerNewsPhotos = (ViewPager)findViewById(R.id.pager_news_photo);
        mNewsPhotoPagerAdapter = new PhotoCouponPagerAdapter(this, mLstNewsPhotos);
        mPagerNewsPhotos.setAdapter(mNewsPhotoPagerAdapter);

        mPageIndicatorNews = (CirclePageIndicator)findViewById(R.id.page_indicator_news_photo);
        mPageIndicatorNews.setViewPager(mPagerNewsPhotos);
        mPageIndicatorNews.setFillColor(ContextCompat.getColor(mContext, R.color.blue_sky));
        mPageIndicatorNews.setStrokeColor(ContextCompat.getColor(mContext, R.color.grey));

    }

    protected Handler mHanlderGetNewsDetail = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseNewsDetailData news = (ResponseNewsDetailData) msg.obj;
                    if (news.code == APIConstants.REQUEST_OK && news.httpCode == APIConstants.HTTP_OK) {
                        setTitle(news.data.getmTitle());
                        mTvNewsCat.setText(news.data.getmCategory().getmName());
                        mTvNewsTitle.setText(news.data.getmTitle());
                        mTvNewsDate.setText(CommonUtils.convertDateFormat(news.data.getmTime()));
                        mTvNewsDescription.setText(news.data.getmDescription());

                        if(news.data.getmLstNewPhotos() != null) {
                            mLstNewsPhotos = news.data.getmLstNewPhotos();
                            mNewsPhotoPagerAdapter.updatePhotos(mLstNewsPhotos);
                            mRlPhotos.setVisibility(View.VISIBLE);
                        } else {
                            mRlPhotos.setVisibility(View.GONE);
                        }
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), true);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), true);
                    break;
            }
        }
    };
}
