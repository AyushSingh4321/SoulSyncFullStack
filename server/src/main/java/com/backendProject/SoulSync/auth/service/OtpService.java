package com.backendProject.SoulSync.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
public class OtpService
{
    @Autowired
    private JavaMailSender gmailSender;
    private final String ADMIN_GMAIL_ID="ayushksb11@gmail.com";

    public void SendOtpToAdmin(String email)
    {
        String otp=String.format("%05d",new Random().nextInt(100000));
        SimpleMailMessage message=new SimpleMailMessage();
        message.setFrom(ADMIN_GMAIL_ID);
        message.setTo(email);
        message.setText("Your OTP for verification in SoulSync app : "+otp);
        message.setSubject("OTP Verification");
        gmailSender.send(message);
        saveOtp(email,otp);
    }
    @Autowired
    private StringRedisTemplate redisTemplate;

    private static final long OTP_EXPIRATION_MINUTES = 1;

    public void saveOtp(String email, String otp) {
        redisTemplate.opsForValue().set(email, otp, OTP_EXPIRATION_MINUTES, TimeUnit.MINUTES);
    }

    public String getOtp(String email) {
        return redisTemplate.opsForValue().get(email);
    }

    public void deleteOtp(String email) {
        redisTemplate.delete(email);
    }
}
