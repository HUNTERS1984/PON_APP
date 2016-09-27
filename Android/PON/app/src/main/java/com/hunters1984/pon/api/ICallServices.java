package com.hunters1984.pon.api;

import com.hunters1984.pon.models.ResponseCommonModel;
import com.hunters1984.pon.models.ResponseUserDataModel;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

/**
 * Created by LENOVO on 4/21/2016.
 */
public interface ICallServices {

    @FormUrlEncoded
    @POST("/api/v1/signup")
    Call<ResponseCommonModel> signUp(@Field("username") String username, @Field("email") String email, @Field("password") String password);


    @FormUrlEncoded
    @POST("/api/v1/signin")
    Call<ResponseUserDataModel> signIn(@Field("username") String username, @Field("password") String password);

}
