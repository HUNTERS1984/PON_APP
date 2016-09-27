package com.hunters1984.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters1984.pon.models.ResponseCommonModel;
import com.hunters1984.pon.models.ResponseUserDataModel;

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

        Call<ResponseCommonModel> response = service.signUp(username, email, password);

        response.enqueue(new Callback<ResponseCommonModel>() {
            @Override
            public void onResponse(Call<ResponseCommonModel> call, Response<ResponseCommonModel> response) {
                ResponseCommonModel res = response.body();
                Message msg = Message.obtain();
                msg.obj = res.message;
                handler.sendMessage(msg);
                closeDialog();
            }

            @Override
            public void onFailure(Call<ResponseCommonModel> call, Throwable t) {

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

        Call<ResponseUserDataModel> response = service.signIn(username, password);

        response.enqueue(new Callback<ResponseUserDataModel>() {
            @Override
            public void onResponse(Call<ResponseUserDataModel> call, Response<ResponseUserDataModel> response) {
                ResponseUserDataModel res = response.body();
                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_SUCCESS;
                msg.obj = res;
                handler.sendMessage(msg);
                closeDialog();
            }

            @Override
            public void onFailure(Call<ResponseUserDataModel> call, Throwable t) {
                Message msg = Message.obtain();
                msg.what = APIConstants.HANDLER_REQUEST_SERVER_FAILED;
                handler.sendMessage(msg);
                closeDialog();
            }
        });
    }
}
