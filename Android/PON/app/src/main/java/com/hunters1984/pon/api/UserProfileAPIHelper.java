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
 * Created by LENOVO on 9/26/2016.
 */

public class UserProfileAPIHelper extends APIHelper{

    public void signUp(Context context, String username, String email, String password, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        Call<ResponseCommon> response = service.signUp(username, email, password);

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

    public void signIn(Context context, String username, String password, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        Call<ResponseUserData> response = service.signIn(username, password);

        response.enqueue(new Callback<ResponseUserData>() {
            @Override
            public void onResponse(Call<ResponseUserData> call, Response<ResponseUserData> response) {
                ResponseUserData res = response.body();
                if (res == null) {
                    res = new ResponseUserData();
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
            public void onFailure(Call<ResponseUserData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getProfile(Context context, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseProfileData> response = service.getProfile(token);

        response.enqueue(new Callback<ResponseProfileData>() {
            @Override
            public void onResponse(Call<ResponseProfileData> call, Response<ResponseProfileData> response) {
                ResponseProfileData res = response.body();
                if (res == null) {
                    res = new ResponseProfileData();
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
            public void onFailure(Call<ResponseProfileData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void checkValidToken(Context context, String token, final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

        String tokenHeader = Constants.HEADER_AUTHORIZATION.replace("%s", token);

        Call<ResponseCommon> response = service.checkValidToken(tokenHeader);

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
