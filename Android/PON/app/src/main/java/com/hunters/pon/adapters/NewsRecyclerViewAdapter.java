package com.hunters.pon.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hunters.pon.R;
import com.hunters.pon.activities.NewsDetailActivity;
import com.hunters.pon.models.NewsModel;
import com.hunters.pon.utils.Constants;

import java.util.List;

/**
 * Created by LENOVO on 9/18/2016.
 */
public class NewsRecyclerViewAdapter extends RecyclerView.Adapter<NewsRecyclerViewAdapter.NewsRecyclerViewHolders> {

    private List<NewsModel> mListNews;
    private Context mContext;

    public NewsRecyclerViewAdapter(Context context, List<NewsModel> lstNews) {
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
        holder.mNewsTitle.setText(mListNews.get(position).getmTitle());
        String description = mListNews.get(position).getmDescriprion();
        String des = description.substring(0, (description.length() < 71?description.length()-1:70)) + "...<font color=#18C0D4>もっと見る</font>";
        holder.mNewsDescription.setText(Html.fromHtml(des));
        holder.mNewsShortTitle.setText(mListNews.get(position).getmShortTitle());
        holder.mView.setTag(position);
    }

    @Override
    public int getItemCount() {
        return this.mListNews.size();
    }

    public class NewsRecyclerViewHolders extends RecyclerView.ViewHolder implements View.OnClickListener{

        public TextView mNewsTitle;
        public TextView mNewsShortTitle;
        public TextView mNewsDescription;
        public View mView;

        public NewsRecyclerViewHolders(View itemView) {
            super(itemView);
            mView = itemView;
            itemView.setOnClickListener(this);
            mNewsTitle = (TextView)itemView.findViewById(R.id.tv_news_title);
            mNewsShortTitle = (TextView) itemView.findViewById(R.id.tv_news_short_title);
            mNewsDescription = (TextView) itemView.findViewById(R.id.tv_news_description);
        }

        @Override
        public void onClick(View view) {
            int pos = Integer.parseInt(view.getTag().toString());

            Intent iNewsDetail = new Intent(mContext, NewsDetailActivity.class);
            iNewsDetail.putExtra(Constants.EXTRA_ID, 1);
            mContext.startActivity(iNewsDetail);
        }
    }
}
