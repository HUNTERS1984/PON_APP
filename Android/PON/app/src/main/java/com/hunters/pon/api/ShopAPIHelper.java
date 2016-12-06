package com.hunters.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters.pon.R;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.NetworkUtils;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by LENOVO on 9/30/2016.
 */

public class ShopAPIHelper extends APIHelper {

    public void addShopFollow(Context context, long shopId, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
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

            Call<ResponseCommon> response = service.addShopFollow(token, shopId);

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

    public void removeShopFollow(Context context, long shopId, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
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

            Call<ResponseCommon> response = service.removeShopFollow(token, shopId);

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

    public void getShopDetail(Context context, long shopId, final Handler handler)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            showProgressDialog(context);
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

//        String token = "";
//
//        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
//            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
//        }

            Call<ResponseShopDetailData> response = service.getShopDetail(shopId);

            response.enqueue(new Callback<ResponseShopDetailData>() {
                @Override
                public void onResponse(Call<ResponseShopDetailData> call, Response<ResponseShopDetailData> response) {
                    ResponseShopDetailData res = response.body();
                    if (res == null) {
                        res = new ResponseShopDetailData();
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
                public void onFailure(Call<ResponseShopDetailData> call, Throwable t) {
                    handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                    closeDialog();
                }
            });
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void getShopFollowCategory(Context context, String featureType, long catId, String lat, String lng, String pageIndex , final Handler handler, boolean isShowProgress)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            if (isShowProgress) {
                showProgressDialog(context);
            }
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

//        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

            Call<ResponseShopFollowCategoryData> response = service.getShopFollowCategory(featureType, catId, lat, lng, "20", pageIndex);

            response.enqueue(new Callback<ResponseShopFollowCategoryData>() {
                @Override
                public void onResponse(Call<ResponseShopFollowCategoryData> call, Response<ResponseShopFollowCategoryData> response) {
                    ResponseShopFollowCategoryData res = response.body();
                    if (res == null) {
                        res = new ResponseShopFollowCategoryData();
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
                public void onFailure(Call<ResponseShopFollowCategoryData> call, Throwable t) {
                    handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                    closeDialog();
                }
            });
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void getMapShopCoupon(Context context, double lat, double lng, String pageIndex , final Handler handler, boolean isShowProgress)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            if (isShowProgress) {
                showProgressDialog(context);
            }
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

            String token = "";

            if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
                token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
            }

            Call<ResponseMapShopCouponData> response = service.getMapShopCoupon(token, lat, lng, "20", pageIndex);

            response.enqueue(new Callback<ResponseMapShopCouponData>() {
                @Override
                public void onResponse(Call<ResponseMapShopCouponData> call, Response<ResponseMapShopCouponData> response) {
                    ResponseMapShopCouponData res = response.body();
                    if (res == null) {
                        res = new ResponseMapShopCouponData();
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
                public void onFailure(Call<ResponseMapShopCouponData> call, Throwable t) {
                    handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                    closeDialog();
                }
            });
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }

    public void getShopFollow(Context context, String pageIndex , final Handler handler, boolean isShowProgress)
    {
        if(NetworkUtils.isNetworkAvailable(context)) {
            if (isShowProgress) {
                showProgressDialog(context);
            }
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(HOST_NAME)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();

            ICallServices service = retrofit.create(ICallServices.class);

            String token = "";

            if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
                token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
            }

            Call<ResponseShopFollowData> response = service.getShopFollow(token, "20", pageIndex);

            response.enqueue(new Callback<ResponseShopFollowData>() {
                @Override
                public void onResponse(Call<ResponseShopFollowData> call, Response<ResponseShopFollowData> response) {
                    ResponseShopFollowData res = response.body();
                    if (res == null) {
                        res = new ResponseShopFollowData();
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
                public void onFailure(Call<ResponseShopFollowData> call, Throwable t) {
                    handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                    closeDialog();
                }
            });
        } else {
            new DialogUtiils().showDialog(context, context.getString(R.string.network_not_avaiable), false);
        }
    }
}
