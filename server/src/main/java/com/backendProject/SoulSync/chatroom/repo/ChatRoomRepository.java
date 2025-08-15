package com.backendProject.SoulSync.chatroom.repo;

import com.backendProject.SoulSync.chatroom.model.ChatRoomModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoomModel,Integer> {
    Optional<ChatRoomModel> findBySenderIdAndRecipientId(String senderId, String recipientId);
}
