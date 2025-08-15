package com.backendProject.SoulSync.date.repo;

import com.backendProject.SoulSync.date.model.DateRequestModel;
import com.backendProject.SoulSync.user.model.UserModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface DateRequestRepo extends JpaRepository<DateRequestModel, Long> {

    // Fetch all where the user is sender
    List<DateRequestModel> findBySender(UserModel sender);

    // Fetch all where the user is receiver
    List<DateRequestModel> findByReceiver(UserModel receiver);

    // Fetch all where user is either sender or receiver (optional if you still use getAllRequests)
    List<DateRequestModel> findBySenderOrReceiver(UserModel sender, UserModel receiver);

    // Delete any existing mutual request (regardless of sender/receiver)
    @Modifying
    @Query("DELETE FROM DateRequestModel d WHERE " +
            "(d.sender = :user1 AND d.receiver = :user2) OR (d.sender = :user2 AND d.receiver = :user1)")
    void deleteMutualRequests(UserModel user1, UserModel user2);

    @Query("SELECT d FROM DateRequestModel d WHERE " +
            "((d.sender = :user1 AND d.receiver = :user2) OR (d.sender = :user2 AND d.receiver = :user1)) " +
            "AND d.status = 'PENDING'")
    Optional<DateRequestModel> findPendingRequestBetween(UserModel user1, UserModel user2);

}
