package com.hunters1984.pon.api;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;

/**
 * Created by LENOVO on 4/21/2016.
 */
public interface ICallServices {

    @FormUrlEncoded
    @POST("/api/v1/signup")
    Call<ResponseCommon> signUp(@Field("username") String username, @Field("email") String email, @Field("password") String password);

    @FormUrlEncoded
    @POST("/api/v1/signin")
    Call<ResponseUserData> signIn(@Field("username") String username, @Field("password") String password);

    @GET("/api/v1/coupons/{id}")
    Call<ResponseCouponDetailData> getCouponDetail(@Path("id") long id);

}
