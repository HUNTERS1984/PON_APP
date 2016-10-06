package com.hunters1984.pon.api;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
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

    @GET("/api/v1/authorized")
    Call<ResponseCommon> checkValidToken(@Header("Authorization") String token);

    @Multipart
    @POST("/api/v1/profile")
    Call<ResponseUserProfileData> updateProfile(@Header("Authorization") String token,  @Part("name") RequestBody username,  @Part("gender") RequestBody gender, @Part("address") RequestBody address, @Part MultipartBody.Part image);

    //Coupons
    @GET("/api/v1/coupons/{id}")
    Call<ResponseCouponDetailData> getCouponDetail(@Header("Authorization") String token, @Path("id") long id);

    @GET("/api/v1/featured/{type}/coupons")
    Call<ResponseCouponMainTopData> getCouponMainTop(@Header("Authorization") String token, @Path("type") String type, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/categories")
    Call<ResponseCategoryData> getCategory(@Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/featured/{type}/category/{category}/coupons")
    Call<ResponseCouponByCategoryData> getCouponByCategory(@Path("type") String type, @Path("category") long categoryId, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/favorite/coupons")
    Call<ResponseMyFavouriteData> getFavouriteCoupons(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/used/coupons")
    Call<ResponseHistoryCouponData> getHistoryCoupon(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/use/coupons/{id}")
    Call<ResponseCommon> useCoupon(@Header("Authorization") String token, @Query("id") long id);


    //Shop
    @GET("/api/v1/categories/shop")
    Call<ResponseCategoryShopFollowData> getCatShopFollow(@Query("page_size") String size, @Query("page_index") String index);


    @GET("/api/v1/featured/{type}/shops/{category}")
    Call<ResponseShopFollowCategoryData> getShopFollowCategory(@Path("type") String featureType, @Path("category") long typeId, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/follow/shops/{id}")
    Call<ResponseCommon> addShopFollow(@Header("Authorization") String token, @Path("id") long shopId);

    @GET("/api/v1/shops/{id}")
    Call<ResponseShopDetailData> getShopDetail(@Path("id") long shopId);

    @GET("/api/v1/map/{lattitude}/{longitude}/shops")
    Call<ResponseMapShopCouponData> getMapShopCoupon(@Path("lattitude") double lat, @Path("longitude") double lng, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/follow/shops")
    Call<ResponseShopFollowData> getShopFollow(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

}
