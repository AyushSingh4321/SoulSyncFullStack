package com.backendProject.SoulSync.chat.service;

import com.backendProject.SoulSync.chat.model.ChatMessage;
import com.backendProject.SoulSync.chat.repo.ChatMessageRepository;
import com.backendProject.SoulSync.chatroom.service.ChatRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ChatMessageService {
    @Autowired
    ChatMessageRepository repo;
    @Autowired
    ChatRoomService chatRoomService;

    public ChatMessage save(ChatMessage chatMessage)
    {
        var chatId=chatRoomService.getChatRoomId(
                chatMessage.getSenderId(),
                chatMessage.getRecipientId(),
                true)
                .orElseThrow();
        chatMessage.setChatId(chatId);
        repo.save(chatMessage);
        return chatMessage;
    }

    public List<ChatMessage> findChatMessages(
        String senderId,String recipientId
    ){
        var chatId=chatRoomService.getChatRoomId(
                senderId,
                recipientId,
                false);
        return chatId.map(repo::findByChatId).orElse(new ArrayList<>());
    }
}
