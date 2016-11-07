package com.hunters.ponstaff.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters.ponstaff.utils.CommonUtils;
import com.hunters.ponstaff.utils.Constants;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by hle59 on 10/31/2016.
 */

public class CouponAPIHelper extends APIHelper {

    public void getRequestCoupon(Context context, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = "";

        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
        }

        Call<ResponseCouponRequestData> response = service.getRequestCoupon(token, "20", pageIndex);

        response.enqueue(new Callback<ResponseCouponRequestData>() {
            @Override
            public void onResponse(Call<ResponseCouponRequestData> call, Response<ResponseCouponRequestData> response) {
                ResponseCouponRequestData res = response.body();
                if (res == null) {
                    res = new ResponseCouponRequestData();
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
            public void onFailure(Call<ResponseCouponRequestData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void declineRequestCoupon(Context context, String code, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = "";

        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
        }

        Call<ResponseCommon> response = service.declineRequestCoupon(token, code);

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

    public void acceptRequestCoupon(Context context, String code, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = "";

        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
        }

        Call<ResponseCommon> response = service.acceptRequestCoupon(token, code);

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
}
