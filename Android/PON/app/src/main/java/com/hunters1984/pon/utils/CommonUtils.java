package com.hunters1984.pon.utils;

import com.hunters1984.pon.api.APIConstants;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by LENOVO on 9/27/2016.
 */

public class CommonUtils {

    public static boolean convertBoolean(int val)
    {
        return (val == APIConstants.TRUE?true:false);
    }

    public static int convertInt(boolean val) {
        return (val?APIConstants.TRUE:APIConstants.FALSE);
    }

    public static String convertDateFormat(String datetime)
    {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss+0000");
        Date testDate = null;
        try {
            testDate = sdf.parse(datetime);
        }catch(Exception ex){
            ex.printStackTrace();
        }
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd");
        return formatter.format(testDate);
    }
}
