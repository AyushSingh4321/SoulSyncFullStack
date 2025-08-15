package com.backendProject.SoulSync.chatroom.service;

import com.backendProject.SoulSync.chatroom.model.ChatRoomModel;
import com.backendProject.SoulSync.chatroom.repo.ChatRoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
public class ChatRoomService {
    @Autowired
    ChatRoomRepository repo;
    public Optional<String> getChatRoomId(
            String senderId,
            String recipientId,
            boolean createNewRoomIfNotExists
    )
    {
        return repo.findBySenderIdAndRecipientId(senderId,recipientId)
                .map(ChatRoomModel::getChatId)
                .or(()->{
                    if(createNewRoomIfNotExists){
                        var chatId=createChatId(senderId,recipientId);
                        return Optional.of(chatId);
                    }
                    return Optional.empty();
                });
    }

    private String createChatId(String senderId, String recipientId) {
        var chatId=String.format(("%s_%s"),senderId,recipientId);
        ChatRoomModel senderRecipient=ChatRoomModel.builder()
                .chatId(chatId)
                .senderId(senderId)
                .recipientId(recipientId)
                .build();

        ChatRoomModel recipientSender=ChatRoomModel.builder()
                .chatId(chatId)
                .senderId(recipientId)
                .recipientId(senderId)
                .build();
        repo.save(senderRecipient);
        repo.save(recipientSender);
        return chatId;
    }
}
