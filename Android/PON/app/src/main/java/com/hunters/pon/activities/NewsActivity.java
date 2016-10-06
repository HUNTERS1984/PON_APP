package com.hunters.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.NewsRecyclerViewAdapter;
import com.hunters.pon.models.NewsModel;
import com.hunters.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class NewsActivity extends BaseActivity implements OnLoadDataListener {

    private List<NewsModel> mLstNews;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mDataListener = this;
        mContext = this;
        setContentView(R.layout.activity_news);
        super.onCreate(savedInstanceState);


        initLayout();
    }

    private void initLayout()
    {
        setTitle(getString(R.string.news) + " 12");

        RecyclerView rvNews = (RecyclerView) findViewById(R.id.rv_news);

        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        rvNews.setLayoutManager(layoutManager);
        NewsRecyclerViewAdapter adapter = new NewsRecyclerViewAdapter(this, mLstNews);
        rvNews.setAdapter(adapter);
    }

    @Override
    public void onLoadData() {
        mLstNews = new ArrayList<>();
        for(int i=0; i<5; i++){
            NewsModel news = new NewsModel();
            news.setmTitle("カテゴリが入ります");
            news.setmShortTitle("タイトルが入ります");
            news.setmDescriprion(getString(R.string.shop_example_text) + "<font color=#18C0D4>もっと見る</font>");
            mLstNews.add(news);
        }

    }
}
