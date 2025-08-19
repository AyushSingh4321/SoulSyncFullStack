package com.backendProject.SoulSync.chatroom.repo;

import com.backendProject.SoulSync.chatroom.model.ChatRoomModel;
import com.backendProject.SoulSync.user.model.UserModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoomModel,Integer> {
    Optional<ChatRoomModel> findBySenderIdAndRecipientId(String senderId, String recipientId);

    @Query("SELECT DISTINCT u FROM UserModel u WHERE u.id IN " +
            "(SELECT DISTINCT CASE WHEN c.senderId = :userId THEN CAST(c.recipientId AS int) ELSE CAST(c.senderId AS int) END " +
            "FROM ChatRoomModel c WHERE c.senderId = :userId OR c.recipientId = :userId)")
    List<UserModel> findChattedUsers(@Param("userId") Integer userId);
}
