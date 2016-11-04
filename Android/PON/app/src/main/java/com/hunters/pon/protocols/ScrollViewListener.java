package com.hunters.pon.protocols;

import android.widget.ScrollView;

/**
 * Created by hle59 on 11/4/2016.
 */

public interface ScrollViewListener {
    void onScrollChanged(ScrollView scrollView,
                         int x, int y, int oldx, int oldy);
}
