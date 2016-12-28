package com.hunters.pon.activities;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.hunters.pon.R;
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.GoogleAnalyticUtils;

public class ProfileTypeInfoActivity extends BaseActivity {

    private int mTypeInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        setContentView(R.layout.activity_profile_type_info);
        super.onCreate(savedInstanceState);

        mTypeInfo = getIntent().getIntExtra(Constants.EXTRA_TYPE_INFO_PROFILE, 0);

        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.PRIVACY_POLICY_SCREEN);
    }

    private void initLayout()
    {
        WebView web = (WebView)findViewById(R.id.wv_privacy);

        WebSettings settings = web.getSettings();
        settings.setJavaScriptEnabled(true);
        web.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);

        final AlertDialog alertDialog = new AlertDialog.Builder(this).create();

        final ProgressDialog progressBar = ProgressDialog.show(this, getString(R.string.privacy_policy), getString(R.string.connecting));

        web.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

            public void onPageFinished(WebView view, String url) {
                if (progressBar.isShowing()) {
                    progressBar.dismiss();
                }
            }

            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                alertDialog.setTitle("Error");
                alertDialog.setMessage(description);
                alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        return;
                    }
                });
                alertDialog.show();
            }
        });

        switch (mTypeInfo){
            case Constants.TYPE_TERM:
                setTitle(getString(R.string.term_of_service));
                web.loadUrl(Constants.URL_TERM_OF_SERVICE);
                break;
            case Constants.TYPE_PRIVACY:
                setTitle(getString(R.string.privacy_policy));
                web.loadUrl(Constants.URL_PRIVACY_POLICY);
                break;
            case Constants.TYPE_TRADE:
                setTitle(getString(R.string.specific_trade));
                web.loadUrl(Constants.URL_SPECIFIC_TRADE);
                break;
            case Constants.TYPE_CONTACT:
                setTitle(getString(R.string.contact_us));
                web.loadUrl(Constants.URL_CONTACT_US);
                break;
            case Constants.TYPE_HOPE_LIKE_SHOP:
                setTitle(getString(R.string.post_hope_of_shop_like));
                web.loadUrl(Constants.URL_HOPE_LIKE_SHOP);
                break;
        }

    }
}
