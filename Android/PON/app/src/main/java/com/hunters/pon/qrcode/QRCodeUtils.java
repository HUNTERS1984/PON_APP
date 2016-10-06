package com.hunters.pon.qrcode;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.view.Display;
import android.view.WindowManager;
import android.widget.ImageView;

import com.google.zxing.BarcodeFormat;

/**
 * Created by LENOVO on 9/20/2016.
 */

public class QRCodeUtils {
    public void genQRCode(Context context, String data, ImageView ivQRCode)
    {
        WindowManager manager = (WindowManager) context.getSystemService(context.WINDOW_SERVICE);
        Display display = manager.getDefaultDisplay();
        Point point = new Point();
        display.getSize(point);
        int width = point.x;
        int height = point.y;
        int smallerDimension = width < height ? width : height;

        QRCodeEncoder qrCodeEncoder = new QRCodeEncoder(data,
                null,
                Contents.Type.TEXT,
                BarcodeFormat.QR_CODE.toString(),
                smallerDimension);
        try {
            Bitmap bitmap = qrCodeEncoder.encodeAsBitmap();
            ivQRCode.setImageBitmap(bitmap);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
