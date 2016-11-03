package com.hunters.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters.pon.R;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.NetworkUtils;

import java.io.File;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
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
        if(NetworkUtils.isNetworkAvailable(context)) {
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
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void signIn(Context context, String username, String password, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
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
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void getProfile(Context context, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
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
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void checkValidToken(Context context, String token, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
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
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void updateProfile(Context context, String username, String email, String gender, String address, String avatarPath, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            showProgressDialog(context);
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

            String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

//        Map<String, RequestBody> map = new HashMap<>();
//        File file = new File(avatarPath);
//
//        RequestBody requestBody = RequestBody.create(MediaType.parse("*/*"), file);
//        map.put("file\"; filename=\"" + file.getName() + "\"", requestBody);

            RequestBody nameUser = RequestBody.create(MediaType.parse("text/plain"), username);
            RequestBody emailUser = RequestBody.create(MediaType.parse("text/plain"), email);
            RequestBody genderUser = RequestBody.create(MediaType.parse("text/plain"), gender);
            RequestBody addressUser = RequestBody.create(MediaType.parse("text/plain"), address);

            Call<ResponseUserProfileData> response;
            if (avatarPath != null) {
                File file = new File(avatarPath);
                RequestBody avatar = RequestBody.create(MediaType.parse("image/*"), file);
                MultipartBody.Part body = MultipartBody.Part.createFormData("avatar_url", file.getName(), avatar);
                response = service.updateProfile(token, nameUser, emailUser, genderUser, addressUser, body);
            } else {
                response = service.updateProfile(token, nameUser, emailUser, genderUser, addressUser, null);
            }

            if (response != null) {
                response.enqueue(new Callback<ResponseUserProfileData>() {
                    @Override
                    public void onResponse(Call<ResponseUserProfileData> call, Response<ResponseUserProfileData> response) {
                        ResponseUserProfileData res = response.body();
                        if (res == null) {
                            res = new ResponseUserProfileData();
                            res.code = APIConstants.REQUEST_FAILED;
                        }
                        res.httpCode = response.code();

                        Message msg = Message.obtain();
                        msg.what = APIConstants.HANDLER_REQUEST_SERVER_SUCCESS;
                        msg.obj = res;
                        handler.sendMessage(msg);
                        closeDialog();
                    }

                    @Override
                    public void onFailure(Call<ResponseUserProfileData> call, Throwable t) {
                        handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                        closeDialog();
                    }
                });
            }
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void signInFacebook(Context context, String token, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            showProgressDialog(context);
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

            Call<ResponseUserData> response = service.signInFacebook(token);

            response.enqueue(new Callback<ResponseUserData>() {
                @Override
                public void onResponse(Call<ResponseUserData> call, Response<ResponseUserData> response) {
                    ResponseUserData res = response.body();
                    if (res == null) {
                        res = new ResponseUserData();
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void signInTwitter(Context context, String accessToken, String secretToken, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            showProgressDialog(context);
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

            Call<ResponseUserData> response = service.signInTwitter(accessToken, secretToken);

            response.enqueue(new Callback<ResponseUserData>() {
                @Override
                public void onResponse(Call<ResponseUserData> call, Response<ResponseUserData> response) {
                    ResponseUserData res = response.body();
                    if (res == null) {
                        res = new ResponseUserData();
                        res.code = APIConstants.REQUEST_FAILED;
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
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }
}
