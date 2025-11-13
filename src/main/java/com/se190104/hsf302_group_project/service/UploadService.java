package com.se190104.hsf302_group_project.service;

import jakarta.servlet.ServletContext;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Service
public class UploadService {
    private final ServletContext servletContext;

    public UploadService(
            ServletContext servletContext) {

        this.servletContext = servletContext;
    }

    public String handleSaveUploadFile(MultipartFile file, String targetFolder) {
        // don't upload file
        if (file.isEmpty())
            return "";
        // relative path: absolute path
        String rootPath = this.servletContext.getRealPath("/resources/static/images");
        String finalName = "";
        try {
            byte[] bytes = file.getBytes();

            File dir = new File(rootPath + File.separator + targetFolder);
            if (!dir.exists())
                dir.mkdirs();

            // Create the file on server
            finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();

            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);
            // uuid

            Thumbnails.of(file.getInputStream())
                    .size(500, 350)     // ép về đúng 500x350
                    .keepAspectRatio(false) // bắt buộc đúng tỷ lệ, không giữ tỉ lệ gốc
                    .outputFormat("jpg")    // tùy chọn, có thể dùng "png"
                    .toFile(serverFile);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return finalName;
    }

}
