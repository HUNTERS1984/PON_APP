package com.hunters.ponstaff.activities;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.zxing.Result;
import com.hunters.ponstaff.R;
import com.hunters.ponstaff.protocols.OnDialogButtonConfirm;
import com.hunters.ponstaff.utils.DialogUtils;

import me.dm7.barcodescanner.zxing.ZXingScannerView;

public class QRReaderActivity extends AppCompatActivity implements ZXingScannerView.ResultHandler,  ActivityCompat.OnRequestPermissionsResultCallback {

    private static final int REQUEST_CAMERA = 0;

    private Context mContext;
    private ZXingScannerView mScannerView;
    private View mLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrreader);
        mContext = this;
        mLayout = findViewById(R.id.activity_qrreader);

        initLayout();

        showCamera();
    }

    private void initLayout()
    {
        TextView tvTitle = (TextView)findViewById(R.id.tv_title);
        tvTitle.setText(getString(R.string.qr_reader));
        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
    }

    @Override
    public void handleResult(Result rawResult) {

        Log.e("handler", rawResult.getText()); // Prints scan results
        Log.e("handler", rawResult.getBarcodeFormat().toString()); // Prints the scan format (qrcode)

        // show the scanner result into dialog box.
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Scan Result");
        builder.setMessage(rawResult.getText());
        AlertDialog alert1 = builder.create();
        alert1.show();

    }

    public void showCamera() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            requestCameraPermission();

        } else {
            showCameraPreview();
        }

    }

    private void showCameraPreview()
    {
        FrameLayout qrReader = (FrameLayout) findViewById(R.id.qr_reader);
        mScannerView = new ZXingScannerView(this);   // Programmatically initialize the scanner view
        qrReader.addView(mScannerView);

        mScannerView.setResultHandler(this); // Register ourselves as a handler for scan results.
        mScannerView.startCamera();
    }
    private void requestCameraPermission() {

        if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                Manifest.permission.CAMERA)) {
            new DialogUtils().showDialog(mContext, getString(R.string.permission_camera_rationale), new OnDialogButtonConfirm() {
                @Override
                public void onDialogButtonConfirm() {
                    ActivityCompat.requestPermissions(QRReaderActivity.this,
                            new String[]{Manifest.permission.CAMERA},
                            REQUEST_CAMERA);
                }
            });
        } else {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA},
                    REQUEST_CAMERA);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {

        if (requestCode == REQUEST_CAMERA) {
            if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                showCamera();
            } else {
                new DialogUtils().showDialog(mContext, getString(R.string.camera_permissions_not_granted), false);
//                showCamera();
            }

        }  else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
}
