package com.backendProject.SoulSync.config;

import com.backendProject.SoulSync.auth.service.JwtService;
import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.security.Principal;
import java.util.Map;
import java.util.Optional;

@Component
public class JwtHandshakeInterceptor implements HandshakeInterceptor {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserRepo userRepo;

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
        String authHeader = request.getHeaders().getFirst("Authorization");
        System.out.println("Interceptor 1  "+authHeader);
        if (authHeader != null && authHeader.startsWith("Bearer ")) {

            String token = authHeader.substring(7);
            String email = jwtService.extractEmail(token);
            System.out.println("Interceptor 2  "+email);
            Optional<UserModel> optionalUser = userRepo.findByEmail(email);

            if (optionalUser.isPresent()) {
                UserModel user = optionalUser.get();
                System.out.println("Interceptor 3 "+user.getEmail());
                // Save Principal in attributes so it can be set later
                attributes.put("user", new StompPrincipal(String.valueOf(user.getId()))); // this is the key part
//                attributes.put("user", new StompPrincipal(user));
            }
        }

        return true;
    }

//    USED ONLY IN BROWSERS
// src/main/java/com/backendProject/SoulSync/config/JwtHandshakeInterceptor.java
//@Override
//public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
//                               WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
//    String token = null;
//    if (request instanceof org.springframework.http.server.ServletServerHttpRequest) {
//        String query = ((org.springframework.http.server.ServletServerHttpRequest) request)
//                .getServletRequest().getQueryString();
//        if (query != null && query.contains("token=")) {
//            token = query.split("token=")[1];
//        }
//    }
//    System.out.println("Interceptor 1  " + token);
//    if (token != null) {
//        String email = jwtService.extractEmail(token);
//        Optional<UserModel> optionalUser = userRepo.findByEmail(email);
//        if (optionalUser.isPresent()) {
//            UserModel user = optionalUser.get();
//            attributes.put("user", new StompPrincipal(String.valueOf(user.getId())));
//        }
//    }
//    return true;
//}

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {
    }

//    =======================BEFORE
    public static class StompPrincipal implements Principal {
        private final String name;

        public StompPrincipal(String name)
        {
            System.out.println("Interceptor 4 "+name );
            this.name = name;
        }

        @Override
        public String getName() {
            return name;
        }
    }

}