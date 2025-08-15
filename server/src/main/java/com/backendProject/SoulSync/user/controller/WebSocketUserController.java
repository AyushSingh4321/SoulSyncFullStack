package com.backendProject.SoulSync.user.controller;

import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class WebSocketUserController {
    @Autowired
    UserService userService;

    //    =================Controllers for User Chat data================
    @MessageMapping("/user.connectUser")
    @SendToUser("/queue/status")
    public String connectUser(@Payload Integer id) {
        return userService.saveStatus(id);
    }

    @MessageMapping("/user.disconnectUser")
    @SendToUser("/queue/status")
    public String disconnect(@Payload Integer id) {
        return userService.disconnect(id);
    }


}
