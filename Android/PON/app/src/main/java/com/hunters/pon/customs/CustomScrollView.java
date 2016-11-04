package com.hunters.pon.customs;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

import com.hunters.pon.protocols.ScrollViewListener;

/**
 * Created by hle59 on 11/4/2016.
 */

public class CustomScrollView extends ScrollView {
    private ScrollViewListener scrollViewListener = null;
    public CustomScrollView(Context context) {
        super(context);
    }

    public CustomScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomScrollView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void setScrollViewListener(ScrollViewListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
        if (scrollViewListener != null) {
            scrollViewListener.onScrollChanged(this, l, t, oldl, oldt);
        }
    }
}
