package com.hunters.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.NewsDetailActivity;
import com.hunters.pon.api.ResponseNews;
import com.hunters.pon.utils.Constants;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by LENOVO on 9/18/2016.
 */
public class NewsRecyclerViewAdapter extends RecyclerView.Adapter<NewsRecyclerViewAdapter.NewsRecyclerViewHolders> {

    private List<ResponseNews> mListNews;
    private Context mContext;

    public NewsRecyclerViewAdapter(Context context, List<ResponseNews> lstNews) {
        this.mListNews = lstNews;
        this.mContext = context;
    }

    @Override
    public NewsRecyclerViewHolders onCreateViewHolder(ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.news_item, null);
        NewsRecyclerViewHolders holders = new NewsRecyclerViewHolders(view);
        return holders;
    }

    @Override
    public void onBindViewHolder(NewsRecyclerViewHolders holder, int position) {
        ResponseNews news = mListNews.get(position);
        holder.mNewsCat.setText(news.getmCategory().getmName());
        String introduction = news.getmIntroduction();
        String intro = introduction.substring(0, (introduction.length() < 51?introduction.length()-1:50)) + "...<font color=#18C0D4>もっと見る</font>";
        holder.mNewsIntroduction.setText(Html.fromHtml(intro));
        holder.mNewsTitle.setText(news.getmTitle());
        Picasso.with(mContext)
                .load(news.getmUrlImage())
                .noFade()
                .fit()
                .into(holder.mNewsImage);
        holder.mView.setTag(position);
    }

    public void updateData(List<ResponseNews> lstNews)
    {
        mListNews = lstNews;
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return this.mListNews.size();
    }

    public class NewsRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mNewsCat;
        public TextView mNewsTitle;
        public TextView mNewsIntroduction;
        public ImageView mNewsImage;
        public View mView;

        public NewsRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mNewsCat = (TextView)itemView.findViewById(R.id.tv_news_cat);
            mNewsTitle = (TextView) itemView.findViewById(R.id.tv_news_title);
            mNewsIntroduction = (TextView) itemView.findViewById(R.id.tv_news_introduction);
            mNewsImage = (ImageView) itemView.findViewById(R.id.iv_news_image);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());
            ResponseNews news = mListNews.get(pos);
            Intent iNewsDetail = new Intent(mContext, NewsDetailActivity.class);
            iNewsDetail.putExtra(Constants.EXTRA_ID, news.getmId());
            mContext.startActivity(iNewsDetail);
        }
    }
}
