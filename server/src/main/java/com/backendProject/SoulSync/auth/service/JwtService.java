package com.backendProject.SoulSync.auth.service;

import com.backendProject.SoulSync.user.model.UserModel;
import io.github.cdimascio.dotenv.Dotenv;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {
    Dotenv dotenv = Dotenv.load();
    private String secretKey = dotenv.get("JWT_SECRET");
    private static final long JWT_EXPIRATION_MS = 1000L * 60 * 60 * 24 * 30;
    public String generateToken(String email) {
//        System.out.println("********************************"+secretKey);
        Map<String, Object> claims = new HashMap<>();
        return Jwts.builder()
                .claims()
                .add(claims)
                .subject(email)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + JWT_EXPIRATION_MS))
                .and()
                .signWith(getKey())
                .compact();


    }

    private SecretKey getKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
//        System.out.println("***************************************"+Keys.hmacShaKeyFor(keyBytes));
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractEmail(String token) {
        // extract the username from jwt token
        return extractClaim(token, Claims::getSubject);
    }

    private <T> T extractClaim(String token, Function<Claims, T> claimResolver) {
        final Claims claims = extractAllClaims(token);
        return claimResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();


    }

    public boolean validateToken(String token, UserModel userDetails) {
        final String userEmail = extractEmail(token);
        System.out.println("Step 4(Validate token method) userEmail: " + userEmail);
        System.out.println("Step 4(Validate token method) Token to be validate is : " + token);
        System.out.println("Step 4(Validate token method) is email equal : " + userEmail.equals(userDetails.getEmail()) + "is Token not expired : " + !isTokenExpired(token));
        return (userEmail.equals(userDetails.getEmail()) && !isTokenExpired(token));
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }


}

