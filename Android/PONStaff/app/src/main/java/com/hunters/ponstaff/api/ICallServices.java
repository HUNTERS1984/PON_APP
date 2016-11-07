package com.hunters.ponstaff.api;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

/**
 * Created by hle59 on 10/31/2016.
 */

public interface ICallServices {

    //User API
    @FormUrlEncoded
    @POST("/api/v1/signin")
    Call<ResponseUserData> signIn(@Field("username") String username, @Field("password") String password);


    //Coupon API
    @GET("/api/v1/request/coupons")
    Call<ResponseCouponRequestData> getRequestCoupon(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/decline/coupons/{code}")
    Call<ResponseCommon> declineRequestCoupon(@Header("Authorization") String token, @Path("code") String code);

    @POST("/api/v1/accept/coupons/{code}")
    Call<ResponseCommon> acceptRequestCoupon(@Header("Authorization") String token, @Path("code") String code);
}
