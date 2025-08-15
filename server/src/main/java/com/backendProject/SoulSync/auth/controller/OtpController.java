package com.backendProject.SoulSync.auth.controller;

import com.backendProject.SoulSync.auth.model.OtpRequestModel;
import com.backendProject.SoulSync.auth.service.OtpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class OtpController
{
    @Autowired
    private OtpService otpService;
    @GetMapping("/sendotp/{email}")
    public ResponseEntity<String> sendOtp(@PathVariable String email)
    {
        try {
            otpService.SendOtpToAdmin(email);
            return ResponseEntity.ok("OTP sent to admin");
        }
        catch (Exception e)
        {
            return ResponseEntity.status(500).body(e.getMessage()+ ": OTP not sent");
        }
    }
    @PostMapping("/validateotp")
    public ResponseEntity<String> validateOtp(@RequestBody OtpRequestModel request) {
        try {
            String storedOtp = otpService.getOtp(request.getEmail());
            if (storedOtp == null) {
                return ResponseEntity.status(404).body("OTP expired or not found");
            }

            if (storedOtp.equals(request.getOtp())) {
                otpService.deleteOtp(request.getEmail()); // Optional: delete after use
                return ResponseEntity.ok("OTP is correct");
            } else {
                return ResponseEntity.status(400).body("Invalid OTP");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }


    }
}
