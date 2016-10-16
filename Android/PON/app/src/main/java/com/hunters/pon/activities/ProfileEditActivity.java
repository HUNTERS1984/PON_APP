package com.hunters.pon.activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Spinner;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.hunters.pon.R;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseUserProfileData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.UserModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.ImageUtils;
import com.hunters.pon.utils.PermissionUtils;
import com.squareup.picasso.Picasso;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ProfileEditActivity extends BaseActivity implements OnLoadDataListener {

    private static final int REQUEST_CAMERA = 0, SELECT_FILE = 1;
    private static final int TAKE_PHOTO = 0, GALLERY = 1;

    private Spinner mSpnSex, mSpnPrefecture;
    private ImageView mIvUserPhoto, mIvDeleteUsername, mIvDeleteEmail;

    private EditText mEdtUserName, mEdtEmail;
    private Button mBtnUpdateProfile;

    private UserModel mUser;
    private String mFilePath;

    private int mUserChoosenTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);

        setContentView(R.layout.activity_edit_profile);
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.edit_profile));

        mUser = (UserModel) getIntent().getSerializableExtra(Constants.EXTRA_USER);
        initLayout();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        switch (requestCode) {
            case PermissionUtils.MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    if(mUserChoosenTask == TAKE_PHOTO)
                        cameraIntent();
                    else if(mUserChoosenTask == GALLERY)
                        galleryIntent();
                } else {
                    //code for deny
                }
                break;
        }
    }

    @Override
    public void onLoadData() {
//            new UserProfileAPIHelper().getProfile(mContext, mHanlderGetProfile);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == SELECT_FILE)
                onSelectFromGalleryResult(data);
            else if (requestCode == REQUEST_CAMERA)
                onCaptureImageResult(data);
        }
    }

    private void onCaptureImageResult(Intent data) {
        Bitmap thumbnail = (Bitmap) data.getExtras().get("data");
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        thumbnail.compress(Bitmap.CompressFormat.JPEG, 90, bytes);

        File destination = new File(Environment.getExternalStorageDirectory(),
                System.currentTimeMillis() + ".jpg");

        FileOutputStream fo;
        try {
            destination.createNewFile();
            fo = new FileOutputStream(destination);
            fo.write(bytes.toByteArray());
            fo.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        mFilePath = destination.getAbsolutePath();
        Picasso.with(mContext).load(destination)
                .fit()
                .placeholder(R.drawable.ic_avarta_user)
                .into(mIvUserPhoto);
    }

    @SuppressWarnings("deprecation")
    private void onSelectFromGalleryResult(Intent data) {

        Bitmap bmp = null;
        String path = "";
        if (data != null) {
            try {
                bmp = MediaStore.Images.Media.getBitmap(getApplicationContext().getContentResolver(), data.getData());
                path = MediaStore.Images.Media.insertImage(this.getContentResolver(), bmp, "PonUserPhoto", null);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        mFilePath = ImageUtils.getPath(mContext, data.getData());
        Picasso.with(mContext).load(path)
                .fit()
                .placeholder(R.drawable.ic_avarta_user)
                .into(mIvUserPhoto);

    }

    private void initLayout()
    {
        mIvUserPhoto = (ImageView)findViewById(R.id.iv_user_pic);
        mIvUserPhoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selectImage();
            }
        });

        mEdtUserName = (EditText) findViewById(R.id.edt_username);
        mEdtEmail = (EditText) findViewById(R.id.edt_email);

        mIvDeleteUsername = (ImageView)findViewById(R.id.iv_delete_username);
        mIvDeleteEmail = (ImageView)findViewById(R.id.iv_delete_email);

        mIvDeleteEmail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mEdtEmail.setText("");
            }
        });
        mIvDeleteUsername.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mEdtUserName.setText("");
            }
        });

        mBtnUpdateProfile = (Button) findViewById(R.id.btn_update_profile);
        mBtnUpdateProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String username = mEdtUserName.getText().toString();
                String email = mEdtEmail.getText().toString();
                String sex = String.valueOf(mSpnSex.getSelectedItemPosition());
                String address = mSpnPrefecture.getSelectedItem().toString();
                new UserProfileAPIHelper().updateProfile(mContext, username, sex, address,  mFilePath, mHanlderUpdateProfile);
            }
        });

        mSpnSex = (Spinner)findViewById(R.id.spn_sex);

        List<String> sex = new ArrayList<String>();
        sex.add(getString(R.string.male));
        sex.add(getString(R.string.female));

        ArrayAdapter<String> sexAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, sex);
        sexAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mSpnSex.setAdapter(sexAdapter);

        mSpnPrefecture = (Spinner)findViewById(R.id.spn_prefecture);

        List<String> prefectures = new ArrayList<>(Arrays.asList(getResources().getStringArray(R.array.prefecture)));

        // Creating adapter for spinner
        ArrayAdapter<String> prefectureAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, prefectures );
        prefectureAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        mSpnPrefecture.setAdapter(prefectureAdapter);

        popularUI(mUser);
    }

    private Handler mHanlderUpdateProfile = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:

                    ResponseUserProfileData profile = (ResponseUserProfileData) msg.obj;
                    if (profile.code == APIConstants.REQUEST_OK && profile.httpCode == APIConstants.HTTP_OK) {
//                        UserModel user = profile.data;
//                        popularUI(user);
                    } else {

                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private void popularUI(UserModel user)
    {
        mEdtUserName.setText(user.getmUsername());
        mEdtEmail.setText(user.getmEmail());

        if(user.getmAvatarUrl() != null) {
            Picasso.with(mContext).load(user.getmAvatarUrl())
                    .fit()
                    .into(mIvUserPhoto);
        }
    }

    private void selectImage() {
        final CharSequence[] items = { getString(R.string.take_photo), getString(R.string.photo_from_gallery),
                getString(R.string.cancel) };

        AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
        builder.setTitle(getString(R.string.select_photo));
        builder.setItems(items, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                boolean result = PermissionUtils.checkPermission(mContext);

                if (items[item].equals(getString(R.string.take_photo))) {
                    mUserChoosenTask = TAKE_PHOTO;
                    if(result)
                        cameraIntent();

                } else if (items[item].equals(getString(R.string.photo_from_gallery))) {
                    mUserChoosenTask = GALLERY;
                    if(result)
                        galleryIntent();

                } else if (items[item].equals(getString(R.string.cancel))) {
                    dialog.dismiss();
                }
            }
        });
        builder.show();
    }

    private void galleryIntent()
    {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, getString(R.string.select_file)),SELECT_FILE);
    }

    private void cameraIntent()
    {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        startActivityForResult(intent, REQUEST_CAMERA);
    }

//    private String getRealPathFromURI(Uri contentURI) {
//        String [] proj={MediaStore.Images.Media.DATA};
//        Cursor cursor = getContentResolver().query( contentURI,
//                proj, // Which columns to return
//                null,       // WHERE clause; which rows to return (all rows)
//                null,       // WHERE clause selection arguments (none)
//                null); // Order-by clause (ascending by name)
//        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
//        cursor.moveToFirst();
//
//        return cursor.getString(column_index);
//
//    }
}
