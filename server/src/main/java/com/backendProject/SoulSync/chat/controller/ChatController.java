package com.backendProject.SoulSync.chat.controller;

import com.backendProject.SoulSync.chat.model.ChatMessage;
import com.backendProject.SoulSync.chat.service.ChatMessageService;
import com.backendProject.SoulSync.chat.dto.ChatNotification;
import com.backendProject.SoulSync.user.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;
import java.util.List;

@Controller
public class ChatController {
    @Autowired
    SimpMessagingTemplate messagingTemplate;
    @Autowired
    ChatMessageService chatMessageService;
    @Autowired
    UserRepo repo;
    @MessageMapping("/chat")
    public void processMessage(
            @Payload ChatMessage chatMessage
    ){
        System.out.println("Message is "+chatMessage);
        ChatMessage savedMsg=chatMessageService.save(chatMessage);
//        john/queue/messages

        messagingTemplate.convertAndSendToUser(
                String.valueOf(savedMsg.getRecipientId()),
//                "ayushksb12@gmail.com",//just for testing
                "/queue/messages", ChatNotification.builder()
                                .id(savedMsg.getId())
                                .senderId(savedMsg.getSenderId())
                                .recipientId(savedMsg.getRecipientId())
                                .content(savedMsg.getContent())
                        .build()
        );
    }
//    For testing only
    @MessageMapping("/debug")
    public void debugAuth(Principal principal) {
        System.out.println("✅ Principal: " + (principal != null ? principal.getName() : "null"));
    }

    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(
            @PathVariable("senderId") String senderId,
            @PathVariable("recipientId") String recipientId
    )
    {
        return ResponseEntity.ok(chatMessageService.findChatMessages(senderId,recipientId));
    }
}
