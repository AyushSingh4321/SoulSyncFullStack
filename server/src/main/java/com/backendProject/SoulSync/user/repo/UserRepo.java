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

    @Modifying
    @Transactional
    @Query("DELETE FROM UserModel u WHERE u.deactivationReason = 1 AND u.deactivatedAt < :cutoffDate")
    int deleteOldDeactivatedUsers(@Param("cutoffDate") LocalDateTime cutoffDate);
}
