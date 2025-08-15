package com.backendProject.SoulSync.user.controller;

import com.backendProject.SoulSync.user.dto.UserDataDto;
import com.backendProject.SoulSync.user.dto.UserProfileDto;
import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    UserService userService;

    @GetMapping("/users")
    public ResponseEntity<List<UserModel>> findConnectedUsers()
    {
        return ResponseEntity.ok(userService.findConnectedUsers());
    }

//    ================Controllers for other user operations==========
    //    To get the current logged-in user profile
    @GetMapping("/myProfile")
    public ResponseEntity<?> getMyProfile() {
        return userService.getMyProfile();
    }

    //   To update the profile of current logged-in user
    @PostMapping("/updateUserProfile")
    public ResponseEntity<?> updateUserProfile(@RequestBody UserProfileDto userProfile) {
        return userService.updateUserProfile(userProfile);
    }


    //    To like other users by current user
    @PostMapping("/like/{userId}")   //userId is the id of user to be liked
    public ResponseEntity<?> toggleLike(@PathVariable("userId") Integer userId) {
        try {
            return userService.toggleLikeUser(userId);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error liking user");
        }
    }

    //      To get all the users liked by the current user
    @GetMapping("/liked")
    public ResponseEntity<?> getAllLikedUsers() {
        try {
            return ResponseEntity.ok(userService.getAllLikedUsers());

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error getting all the liked users");
        }
    }
//      To fetch all the users on the main screen in the order of their compatibility
//    @GetMapping("/discover")
//    public ResponseEntity<?> discoverUsers() {
//        try {
//            return ResponseEntity.ok(userService.getBestMatchedUsers());
//        } catch (Exception e) {
//            return ResponseEntity.badRequest().body("Error discovering/fetching all users according to compatibility");
//        }
//    }
@GetMapping("/discover")
public ResponseEntity<?> discoverUsers(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "5") int size) {
    try {
        return ResponseEntity.ok(userService.getBestMatchedUsers(page, size));
    } catch (Exception e) {
        return ResponseEntity.badRequest().body("Error discovering/fetching all users");
    }
}

//To delete the current logged-in user with their will
    @DeleteMapping("/disableUser")
    public ResponseEntity<?> disableUser(@RequestParam int reason) {
        if (reason != 1 && reason != 3) {
            return ResponseEntity
                    .badRequest()
                    .body("Invalid reason code. Allowed values are 1 or 3.");
        }
        try {
            return userService.disableUser(reason);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting user");
        }
    }

    //    To report a user by the current logged-in user
    //    userId is the id of the user to be reported
    @PostMapping("/reportUser/{userId}")
    public ResponseEntity<?> reportUser(@PathVariable Integer userId) {
        try {
            return userService.reportUser(userId);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error getting user profile");
        }
    }

    /**
     * API to delete all users with deactivationReason = 1 and deactivatedAt older than 30 days
     * Intended to be triggered by a cron job
     */
    @DeleteMapping("/deleteUserDisabledAccounts")
    public ResponseEntity<?> deleteOldDeactivatedUsers() {
        try {
            int deletedCount = userService.deleteUsersWithReason1OlderThan30Days();
            return ResponseEntity.ok(deletedCount + " accounts deleted which were deactivated by the user more than 30 days ago.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting old deactivated users: " + e.getMessage());
        }
    }

//    To add search functionality
    @GetMapping("/search")
    public ResponseEntity<?> searchUsers(@RequestParam String keyword)
    {
        System.out.println("searching with "+keyword);
        List<UserDataDto> userList=userService.searchUsers(keyword);
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }


}
