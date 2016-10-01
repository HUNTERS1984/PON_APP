package com.hunters1984.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by LENOVO on 9/30/2016.
 */

public class ShopAPIHelper extends APIHelper {

    public void addShopFollow(Context context, double shopId, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCommon> response = service.addShopFollow(token, shopId);

        response.enqueue(new Callback<ResponseCommon>() {
            @Override
            public void onResponse(Call<ResponseCommon> call, Response<ResponseCommon> response) {
                ResponseCommon res = response.body();
                if (res == null) {
                    res = new ResponseCommon();
                    res.code =  APIConstants.REQUEST_FAILED;
                }
                res.httpCode = response.code();

                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_SUCCESS;
                msg.obj = res;
                handler.sendMessage(msg);
                closeDialog();
            }

            @Override
            public void onFailure(Call<ResponseCommon> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getShopDetail(Context context, double shopId, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseShopDetailData> response = service.getShopDetail(token, shopId);

        response.enqueue(new Callback<ResponseShopDetailData>() {
            @Override
            public void onResponse(Call<ResponseShopDetailData> call, Response<ResponseShopDetailData> response) {
                ResponseShopDetailData res = response.body();
                if (res == null) {
                    res = new ResponseShopDetailData();
                    res.code =  APIConstants.REQUEST_FAILED;
                }
                res.httpCode = response.code();

                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_SUCCESS;
                msg.obj = res;
                handler.sendMessage(msg);
                closeDialog();
            }

            @Override
            public void onFailure(Call<ResponseShopDetailData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }
}
