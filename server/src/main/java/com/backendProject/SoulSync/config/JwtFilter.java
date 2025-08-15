package com.backendProject.SoulSync.config;

import com.backendProject.SoulSync.auth.service.JwtService;
import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.repo.UserRepo;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.Optional;

@Component
public class JwtFilter extends OncePerRequestFilter {
    @Autowired
    private JwtService jwtService;
    @Autowired
    private UserRepo userRepo;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        String token = null;
        String email = null;
        try {
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                token = authHeader.substring(7);
                email = jwtService.extractEmail(token);
                System.out.println("Step 1 email " + email);
                System.out.println("Step 1 token " + token);
                if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    Optional<UserModel> optionalUser = userRepo.findByEmail(email);
                    if (optionalUser.isPresent()) {
                        UserModel userDetails = optionalUser.get();
                        System.out.println("Step 2 userDetails id,email,password : " + userDetails.getId() + "," + userDetails.getEmail() + "," + userDetails.getPassword());
                        if (jwtService.validateToken(token, userDetails)) {
                            System.out.println("Step 3 validation");
                            AbstractAuthenticationToken authentication = new AbstractAuthenticationToken(Collections.emptyList()) {
                                @Override
                                public Object getCredentials() {
                                    return null; // Not using password auth
                                }

                                @Override
                                public Object getPrincipal() {
                                    return userDetails;
                                }
                            };
                            authentication.setAuthenticated(true);
                            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                            // Set the authenticated user into the SecurityContext
                            SecurityContextHolder.getContext().setAuthentication(authentication);
                        }
                    }
                }
            }
            filterChain.doFilter(request, response);
        }
        catch (io.jsonwebtoken.security.SignatureException ex) {
            // Invalid signature → unauthorized response
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Invalid or tampered JWT signature.");
            response.getWriter().flush();
        } catch (Exception ex) {
            // Generic exception handler for safety
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Authentication failed: " + ex.getMessage());
            response.getWriter().flush();
        }
    }
}
