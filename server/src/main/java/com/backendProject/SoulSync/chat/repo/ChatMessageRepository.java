package com.backendProject.SoulSync.chat.repo;

import com.backendProject.SoulSync.chat.model.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage,Integer> {

    List<ChatMessage> findByChatId(String s);
}
