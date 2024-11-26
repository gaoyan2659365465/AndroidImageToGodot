package com.example.sharetool;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;


public class ShareReceiverActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_share_receiver);

        try {
            handleSendIntent(getIntent());  // 处理分享内容
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }


    /**
     * 保存文件到指定路径
     *
     * @param context      应用上下文
     * @param sourceUri    文件的 Uri
     * @param targetPath   目标文件的路径（包括文件名）
     * @return 返回 true 表示保存成功，否则返回 false
     */
    public static boolean saveFileFromUri(Context context, Uri sourceUri, String targetPath) {
        ContentResolver resolver = context.getContentResolver();
        try (InputStream inputStream = resolver.openInputStream(sourceUri);
             OutputStream outputStream = new FileOutputStream(new File(targetPath))) {

            if (inputStream == null) {
                System.err.println("Input stream is null. Failed to save file.");
                return false;
            }

            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            System.out.println("File saved successfully to: " + targetPath);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error saving file: " + e.getMessage());
            return false;
        }
    }

    private void handleSendIntent(Intent intent) throws ClassNotFoundException {
        // 如果是图片文件
        if ("image/*".equals(intent.getType())) {
            Uri imageUri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
            if (imageUri != null) {
                String targetPath = getFilesDir().getAbsolutePath() + "/my_image.png";  // 目标路径
                saveFileFromUri(this, imageUri, targetPath);
                finish();
            }
        }
    }
}

