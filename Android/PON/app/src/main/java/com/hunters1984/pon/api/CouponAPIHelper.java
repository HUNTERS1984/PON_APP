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
 * Created by LENOVO on 9/27/2016.
 */

public class CouponAPIHelper extends APIHelper {

    public void getCouponDetail(Context context, double id , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCouponDetailData> response = service.getCouponDetail(token, id);

        response.enqueue(new Callback<ResponseCouponDetailData>() {
            @Override
            public void onResponse(Call<ResponseCouponDetailData> call, Response<ResponseCouponDetailData> response) {
                ResponseCouponDetailData res = response.body();
                if (res == null) {
                    res = new ResponseCouponDetailData();
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
            public void onFailure(Call<ResponseCouponDetailData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getCouponMainTop(Context context, String type, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCouponMainTopData> response = service.getCouponMainTop(token, type, "1", pageIndex);

        response.enqueue(new Callback<ResponseCouponMainTopData>() {
            @Override
            public void onResponse(Call<ResponseCouponMainTopData> call, Response<ResponseCouponMainTopData> response) {
                ResponseCouponMainTopData res = response.body();
                if (res == null) {
                    res = new ResponseCouponMainTopData();
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
            public void onFailure(Call<ResponseCouponMainTopData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getCouponTypeShopFollow(Context context, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCouponTypeShopFollowData> response = service.getCouponTypeShopFollow(token, "1", pageIndex);

        response.enqueue(new Callback<ResponseCouponTypeShopFollowData>() {
            @Override
            public void onResponse(Call<ResponseCouponTypeShopFollowData> call, Response<ResponseCouponTypeShopFollowData> response) {
                ResponseCouponTypeShopFollowData res = response.body();
                if (res == null) {
                    res = new ResponseCouponTypeShopFollowData();
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
            public void onFailure(Call<ResponseCouponTypeShopFollowData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getShopFollowCouponType(Context context, String featureType, double typeId, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseShopFollowCouponTypeData> response = service.getShopFollowCouponType(token, featureType, typeId, "1", pageIndex);

        response.enqueue(new Callback<ResponseShopFollowCouponTypeData>() {
            @Override
            public void onResponse(Call<ResponseShopFollowCouponTypeData> call, Response<ResponseShopFollowCouponTypeData> response) {
                ResponseShopFollowCouponTypeData res = response.body();
                if (res == null) {
                    res = new ResponseShopFollowCouponTypeData();
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
            public void onFailure(Call<ResponseShopFollowCouponTypeData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getCouponType(Context context, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCouponTypeData> response = service.getCouponType(token, "1", pageIndex);

        response.enqueue(new Callback<ResponseCouponTypeData>() {
            @Override
            public void onResponse(Call<ResponseCouponTypeData> call, Response<ResponseCouponTypeData> response) {
                ResponseCouponTypeData res = response.body();
                if (res == null) {
                    res = new ResponseCouponTypeData();
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
            public void onFailure(Call<ResponseCouponTypeData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }
}
