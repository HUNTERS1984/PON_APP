package com.hunters1984.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class CouponAPIHelper extends APIHelper {

    public void getCouponDetail(Context context, long id , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        Call<ResponseCouponDetailData> response = service.getCouponDetail(id);

        response.enqueue(new Callback<ResponseCouponDetailData>() {
            @Override
            public void onResponse(Call<ResponseCouponDetailData> call, Response<ResponseCouponDetailData> response) {
                ResponseCouponDetailData res = response.body();
                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_SUCCESS;
                msg.obj = res;
                handler.sendMessage(msg);
                closeDialog();
            }

            @Override
            public void onFailure(Call<ResponseCouponDetailData> call, Throwable t) {
                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_FAILED;
                handler.sendMessage(msg);
                closeDialog();
            }
        });
    }
}
