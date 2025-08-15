package com.backendProject.SoulSync.auth.service;

import com.backendProject.SoulSync.auth.dto.LoginRequestDto;
import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.repo.UserRepo;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class LoginService {
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private UserRepo userRepo;
    @Autowired
    private JwtService jwtService;

    public ResponseEntity<?> loginUserAndReturnToken(@Valid LoginRequestDto request) {
        Optional<UserModel> optionalUser = userRepo.findByEmail(request.getIdentifier());
        if (optionalUser.isEmpty()) {
            optionalUser = userRepo.findByUsername(request.getIdentifier());
        }

        if (optionalUser.isEmpty()) {
            return ResponseEntity.badRequest().body("Invalid email/username");
        }

        UserModel user = optionalUser.get();

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return ResponseEntity.badRequest().body("Invalid password");
        }

        String token = jwtService.generateToken(user.getEmail()); // or user.getUsername()

        // To enable the user if they deleted their account
        if(!user.getActive() && user.getDeactivationReason() ==1) {
            user.setActive(true);
            user.setDeactivationReason(null);
            user.setDeactivatedAt(null);
            userRepo.save(user);
        return ResponseEntity.ok(token);
        }
        else if(!user.getActive() && user.getDeactivationReason() ==2) {
            return ResponseEntity.badRequest().body("Your account is banned due to reports");
        }
        else if(!user.getActive() && user.getDeactivationReason() ==3) {
            return ResponseEntity.badRequest().body("Your account is deactivated for some reason, please contact support");
        }
        else {
            return ResponseEntity.ok(token);
        }

    }
}
