package com.hunters.pon.api;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;

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

        String token = "";

        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
        }

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

        String token = "";

        if (!CommonUtils.getToken(context).equalsIgnoreCase("")) {
            token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));
        }

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

    public void getCatShopFollow(Context context, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

//        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCategoryShopFollowData> response = service.getCatShopFollow("1", pageIndex);

        response.enqueue(new Callback<ResponseCategoryShopFollowData>() {
            @Override
            public void onResponse(Call<ResponseCategoryShopFollowData> call, Response<ResponseCategoryShopFollowData> response) {
                ResponseCategoryShopFollowData res = response.body();
                if (res == null) {
                    res = new ResponseCategoryShopFollowData();
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
            public void onFailure(Call<ResponseCategoryShopFollowData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getCategory(Context context, String pageIndex , final Handler handler)
    {
        showProgressDialog(context);
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(HOST_NAME)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        ICallServices service = retrofit.create(ICallServices.class);

//        String token = Constants.HEADER_AUTHORIZATION.replace("%s", CommonUtils.getToken(context));

        Call<ResponseCategoryData> response = service.getCategory("1", pageIndex);

        response.enqueue(new Callback<ResponseCategoryData>() {
            @Override
            public void onResponse(Call<ResponseCategoryData> call, Response<ResponseCategoryData> response) {
                ResponseCategoryData res = response.body();
                if (res == null) {
                    res = new ResponseCategoryData();
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
            public void onFailure(Call<ResponseCategoryData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getCouponByCategory(Context context, String type, long catId, String pageIndex , final Handler handler)
    {
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

        Call<ResponseCouponByCategoryData> response = service.getCouponByCategory(type, catId,  "1", pageIndex);

        response.enqueue(new Callback<ResponseCouponByCategoryData>() {
            @Override
            public void onResponse(Call<ResponseCouponByCategoryData> call, Response<ResponseCouponByCategoryData> response) {
                ResponseCouponByCategoryData res = response.body();
                if (res == null) {
                    res = new ResponseCouponByCategoryData();
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
            public void onFailure(Call<ResponseCouponByCategoryData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getFavouriteCoupon(Context context, String pageIndex , final Handler handler)
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

        Call<ResponseMyFavouriteData> response = service.getFavouriteCoupons(token, "1", pageIndex);

        response.enqueue(new Callback<ResponseMyFavouriteData>() {
            @Override
            public void onResponse(Call<ResponseMyFavouriteData> call, Response<ResponseMyFavouriteData> response) {
                ResponseMyFavouriteData res = response.body();
                if (res == null) {
                    res = new ResponseMyFavouriteData();
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
            public void onFailure(Call<ResponseMyFavouriteData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void getHistoryCoupon(Context context, String pageIndex , final Handler handler)
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

        Call<ResponseHistoryCouponData> response = service.getHistoryCoupon(token, "1", pageIndex);

        response.enqueue(new Callback<ResponseHistoryCouponData>() {
            @Override
            public void onResponse(Call<ResponseHistoryCouponData> call, Response<ResponseHistoryCouponData> response) {
                ResponseHistoryCouponData res = response.body();
                if (res == null) {
                    res = new ResponseHistoryCouponData();
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
            public void onFailure(Call<ResponseHistoryCouponData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }

    public void useCoupon(Context context, long id , final Handler handler)
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

        Call<ResponseCommon> response = service.useCoupon(token, id);

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

    public void addFavouriteCoupon(Context context, String couponId , final Handler handler)
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

        Call<ResponseCommon> response = service.addFavouriteCoupon(token, couponId);

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

    public void searchCoupon(Context context, String query, String pageIndex , final Handler handler)
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

        Call<ResponseSearchCouponData> response = service.searchCoupon(token, query, "20", pageIndex);

        response.enqueue(new Callback<ResponseSearchCouponData>() {
            @Override
            public void onResponse(Call<ResponseSearchCouponData> call, Response<ResponseSearchCouponData> response) {
                ResponseSearchCouponData res = response.body();
                if (res == null) {
                    res = new ResponseSearchCouponData();
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
            public void onFailure(Call<ResponseSearchCouponData> call, Throwable t) {
                handler.sendEmptyMessage(APIConstants.HANDLER_REQUEST_SERVER_FAILED);
                closeDialog();
            }
        });
    }
}
