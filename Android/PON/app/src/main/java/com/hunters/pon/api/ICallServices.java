package com.hunters.pon.api;

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
    Call<ResponseUserProfileData> updateProfile(@Header("Authorization") String token,  @Part("name") RequestBody username, @Part("email") RequestBody email,  @Part("gender") RequestBody gender, @Part("address") RequestBody address, @Part MultipartBody.Part image);

    @FormUrlEncoded
    @POST("/api/v1/facebook/signin")
    Call<ResponseUserData> signInFacebook(@Field("facebook_access_token") String token);

    @FormUrlEncoded
    @POST("/api/v1/twitter/signin")
    Call<ResponseUserData> signInTwitter(@Field("twitter_access_token") String accessToken, @Field("twitter_access_token_secret") String secrectToken);


    //Coupons
    @GET("/api/v1/coupons/{id}")
    Call<ResponseCouponDetailData> getCouponDetail(@Header("Authorization") String token, @Path("id") long id);

    @GET("/api/v1/featured/{type}/coupons")
    Call<ResponseCouponMainTopData> getCouponMainTop(@Header("Authorization") String token, @Path("type") String type, @Query("latitude") String lat, @Query("longitude") String lng, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/categories")
    Call<ResponseCategoryData> getCategory(@Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/featured/{type}/category/{category}/coupons")
    Call<ResponseCouponByCategoryData> getCouponByCategory(@Header("Authorization") String token, @Path("type") String type, @Path("category") long categoryId, @Query("latitude") String lat, @Query("longitude") String lng, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/favorite/coupons")
    Call<ResponseMyFavouriteData> getFavouriteCoupons(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/used/coupons")
    Call<ResponseHistoryCouponData> getHistoryCoupon(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/request/coupons/{code}")
    Call<ResponseCommon> requestUseCoupon(@Header("Authorization") String token, @Query("code") String code);

    @POST("/api/v1/like/coupons/{id}")
    Call<ResponseCommon> addFavouriteCoupon(@Header("Authorization") String token, @Path("id") String id);

    @GET("/api/v1/search/coupons")
    Call<ResponseSearchCouponData> searchCoupon(@Header("Authorization") String token, @Query("query") String query, @Query("page_size") String size, @Query("page_index") String index);

    //Shop
    @GET("/api/v1/categories/shop")
    Call<ResponseCategoryShopFollowData> getCatShopFollow(@Query("page_size") String size, @Query("page_index") String index);


    @GET("/api/v1/featured/{type}/shops/{category}")
    Call<ResponseShopFollowCategoryData> getShopFollowCategory(@Path("type") String featureType, @Path("category") long typeId, @Query("latitude") String lat, @Query("longitude") String lng, @Query("page_size") String size, @Query("page_index") String index);

    @POST("/api/v1/follow/shops/{id}")
    Call<ResponseCommon> addShopFollow(@Header("Authorization") String token, @Path("id") long shopId);

    @GET("/api/v1/shops/{id}")
    Call<ResponseShopDetailData> getShopDetail(@Path("id") long shopId);

    @GET("/api/v1/map/{latitude}/{longitude}/shops")
    Call<ResponseMapShopCouponData> getMapShopCoupon(@Header("Authorization") String token, @Path("latitude") double lat, @Path("longitude") double lng, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/follow/shops")
    Call<ResponseShopFollowData> getShopFollow(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/news")
    Call<ResponseNewsData> getNews(@Header("Authorization") String token, @Query("page_size") String size, @Query("page_index") String index);

    @GET("/api/v1/news/{id}")
    Call<ResponseNewsDetailData> getNewsDetail(@Path("id") long id);

}
