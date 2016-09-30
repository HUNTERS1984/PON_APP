package com.hunters1984.pon.api;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

/**
 * Created by LENOVO on 4/21/2016.
 */
public interface ICallServices {

    //User Profile
    @FormUrlEncoded
    @POST("/api/v1/signup")
    Call<ResponseCommon> signUp(@Field("username") String username, @Field("email") String email, @Field("password") String password);

    @FormUrlEncoded
    @POST("/api/v1/signin")
    Call<ResponseUserData> signIn(@Field("username") String username, @Field("password") String password);

    @GET("/api/v1/profile")
    Call<ResponseProfileData> getProfile(@Header("Authorization") String token);


    //Coupons
    @GET("/api/v1/coupons/{id}")
    Call<ResponseCouponDetailData> getCouponDetail(@Header("Authorization") String token, @Path("id") double id);

    @GET("/api/v1/featured/{type}/coupons")
    Call<ResponseCouponMainTopData> getCouponMainTop(@Header("Authorization") String token, @Path("type") String type, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/coupon/types/shop")
    Call<ResponseCouponTypeShopFollowData> getCouponTypeShopFollow(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);


    @GET("/api/v1/featured/{type}/shops/{couponType}")
    Call<ResponseShopFollowCouponTypeData> getShopFollowCouponType(@Header("Authorization") String token, @Path("type") String featureType, @Path("couponType") double typeId, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/follow/shops/{id}")
    Call<ResponseCommon> addShopFollow(@Header("Authorization") String token, @Path("id") double shopId);

}
