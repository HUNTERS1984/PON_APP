package com.hunters.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.NewsRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseNews;
import com.hunters.pon.api.ResponseNewsData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;

import java.util.ArrayList;
import java.util.List;

public class NewsActivity extends BaseActivity implements OnLoadDataListener {

    private List<ResponseNews> mLstNews;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private NewsRecyclerViewAdapter mAdapterNews;

    private int mPageTotal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mDataListener = this;
        mContext = this;
        setContentView(R.layout.activity_news);
        super.onCreate(savedInstanceState);


        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.PROFILE_NEWS_SCREEN);
    }

    private void initLayout()
    {
        String newsNumber = getIntent().getStringExtra(Constants.EXTRA_DATA);
        setTitle(getString(R.string.news).replace("%s", newsNumber));

        RecyclerView rvNews = (RecyclerView) findViewById(R.id.rv_news);

        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvNews.setLayoutManager(layoutManager);
        mAdapterNews = new NewsRecyclerViewAdapter(this, mLstNews);
        rvNews.setAdapter(mAdapterNews);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mLstNews.add(null);
                    mAdapterNews.notifyItemInserted(mLstNews.size() - 1);
                    new UserProfileAPIHelper().getNews(mContext, String.valueOf(page + 1), mHanlderGetNews);
                }
            }
        };
        rvNews.addOnScrollListener(mScrollLoadMoreData);

    }

    @Override
    public void onLoadData() {
        mLstNews = new ArrayList<>();
        new UserProfileAPIHelper().getNews(mContext, "1", mHanlderGetNews);
//        for(int i=0; i<5; i++){
//            NewsModel news = new NewsModel();
//            news.setmTitle("カテゴリが入ります");
//            news.setmShortTitle("タイトルが入ります");
//            news.setmDescriprion(getString(R.string.shop_example_text) + "<font color=#18C0D4>もっと見る</font>");
//            mLstNews.add(news);
//        }

    }

    protected Handler mHanlderGetNews = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mLstNews.size() > 0 && mLstNews.get(mLstNews.size() - 1) == null) {
                mLstNews.remove(mLstNews.size() - 1);
                mAdapterNews.notifyItemRemoved(mLstNews.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseNewsData news = (ResponseNewsData) msg.obj;
                    if (news.code == APIConstants.REQUEST_OK && news.httpCode == APIConstants.HTTP_OK) {
                        mPageTotal = news.pagination.getmPageTotal();
                        mLstNews.addAll(news.data);
                        mAdapterNews.updateData(mLstNews);
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    mScrollLoadMoreData.adjustCurrentPage();
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
            mScrollLoadMoreData.setLoaded();
        }
    };
}
