package com.hunters.pon.activities;

import android.os.Bundle;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;

public class NewsDetailActivity extends BaseActivity implements OnLoadDataListener {

    private TextView mTvTitle, mTvShortTitle, mTvDescription, mTvDate;
    private long mId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        setContentView(R.layout.activity_news_detail);
        super.onCreate(savedInstanceState);

        mId = getIntent().getLongExtra(Constants.EXTRA_ID, -1);

        initLayout();
    }


    @Override
    public void onLoadData() {

    }

    private void initLayout()
    {
        setTitle("タイトルが入ります");

        mTvTitle = (TextView)findViewById(R.id.tv_news_title);
        mTvShortTitle = (TextView)findViewById(R.id.tv_news_short_title);
        mTvDate = (TextView)findViewById(R.id.tv_news_date);
        mTvDescription = (TextView)findViewById(R.id.tv_news_description);
    }
}
