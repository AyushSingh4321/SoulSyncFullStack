package com.backendProject.SoulSync.user.repo;

import com.backendProject.SoulSync.enums.UserStatus;
import com.backendProject.SoulSync.user.dto.UserDataDto;
import com.backendProject.SoulSync.user.model.UserModel;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepo extends JpaRepository<UserModel, Integer> {

    Optional<UserModel> findByEmail(String email);

    Optional<UserModel> findByUsername(String username);

    @Query("SELECT u FROM UserModel u WHERE u.email = :email")
    UserModel getUserDetailsByEmail(@Param("email") String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    @Query("SELECT u FROM UserModel u WHERE u.email <> :email")
    List<UserModel> findAllByEmailExcept(@Param("email") String email);

    @Query("SELECT u FROM UserModel u WHERE u.id <> :currentUserId")
    List<UserModel> findAllExceptCurrent(@Param("currentUserId") Integer currentUserId);

    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END FROM UserModel u JOIN u.likedUsers l WHERE u.id = :otherUserId AND l.id = :currentUserId")
    boolean hasLikedBack(@Param("otherUserId") Integer otherUserId, @Param("currentUserId") Integer currentUserId);

    @Query("SELECT new com.backendProject.SoulSync.user.dto.UserDataDto(u.id, u.name, u.age, u.gender, u.bio, u.location, u.interests, u.profileImageUrl, FALSE, u.height, u.sports, u.games, u.relationshipType, u.goesGym, u.shortHair, u.wearGlasses, u.drink, u.smoke) " +
            "FROM UserModel u " +
            "WHERE LOWER(u.name) LIKE :keyword " +
            "OR LOWER(u.bio) LIKE :keyword " +
            "OR LOWER(u.location) LIKE :keyword " +
            "OR LOWER(u.interests) LIKE :keyword " +
            "OR LOWER(u.relationshipType) LIKE :keyword")
    List<UserDataDto> searchUsers(@Param("keyword") String keyword);

    @Query("""
    SELECT new com.backendProject.SoulSync.user.dto.UserDataDto(
        u.id, u.name, u.age, u.gender, u.bio,
        u.location, u.interests, u.profileImageUrl,
        FALSE,
        u.height, u.sports, u.games, u.relationshipType,
        u.goesGym, u.shortHair, u.wearGlasses, u.drink, u.smoke
    )
    FROM UserModel u
    WHERE (
        LOWER(u.name) LIKE :keyword OR
        LOWER(u.bio) LIKE :keyword OR
        LOWER(u.location) LIKE :keyword OR
        LOWER(u.interests) LIKE :keyword OR
        LOWER(u.relationshipType) LIKE :keyword
    )
    AND (:gender IS NULL OR LOWER(u.gender) = LOWER(:gender))
""")
    List<UserDataDto> searchUsers(@Param("keyword") String keyword, @Param("gender") String gender);


    List<UserModel> findAllByStatus(UserStatus userStatus);

    // Query to find users that will be deleted
    @Query("SELECT u FROM UserModel u WHERE u.deactivationReason = 1 AND u.deactivatedAt < :cutoffDate")
    List<UserModel> findUsersToDelete(@Param("cutoffDate") LocalDateTime cutoffDate);

    // Remove date requests where users are either sender or receiver
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM date_request_model WHERE sender_id IN :userIds OR receiver_id IN :userIds", nativeQuery = true)
    void removeDateRequestsForUsers(@Param("userIds") List<Integer> userIds);

    // Remove user likes relationships (required because JPA deleteAllById doesn't always handle @ManyToMany cleanup)
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM user_likes WHERE liker_id IN :userIds OR liked_id IN :userIds", nativeQuery = true)
    void removeLikesForUsers(@Param("userIds") List<Integer> userIds);

    // Remove chat messages where users are sender or recipient (using string IDs)
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM chat_message WHERE sender_id IN :userIds OR recipient_id IN :userIds", nativeQuery = true)
    void removeChatMessagesForUsers(@Param("userIds") List<String> userIds);

    // Remove chat rooms where users are sender or recipient (using string IDs)
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM chat_room_model WHERE sender_id IN :userIds OR recipient_id IN :userIds", nativeQuery = true)
    void removeChatRoomsForUsers(@Param("userIds") List<String> userIds);

    // Note: Using JPA's deleteAllById instead of JPQL DELETE to ensure proper cascade handling
    // The actual deletion will be done via UserService using repository.deleteAllById(userIds)
}
