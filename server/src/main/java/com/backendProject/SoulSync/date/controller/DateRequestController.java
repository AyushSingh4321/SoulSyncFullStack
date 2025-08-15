package com.backendProject.SoulSync.date.controller;

import com.backendProject.SoulSync.date.dto.DateRequestDto;
import com.backendProject.SoulSync.date.service.DateRequestService;
import com.backendProject.SoulSync.user.model.UserModel;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/dateRequest")
public class DateRequestController {

    @Autowired
    private DateRequestService dateRequestService;

    // Send a new date request to another user
    @PostMapping("/send/{receiverId}")
    public ResponseEntity<?> sendDateRequest(@PathVariable int receiverId,
                                             @RequestBody @Valid DateRequestDto dto) {
        try {
            UserModel user = getCurrentUser();
            return ResponseEntity.ok(dateRequestService.sendRequest(user.getEmail(), receiverId, dto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error sending date request: " + e.getMessage());
        }
    }

    // Accept or reject an existing date request
//   URL: url?action=accept or reject
    @PostMapping("/{requestId}/respond")
    public ResponseEntity<?> respondToRequest(@PathVariable Long requestId,
                                              @RequestParam String action) {
        try {
            String actionUpper = action.toUpperCase();
            if (!actionUpper.equals("ACCEPT") && !actionUpper.equals("REJECT")) {
                return ResponseEntity.badRequest().body("Invalid action. Use 'ACCEPT' or 'REJECT'.");
            }

            UserModel user = getCurrentUser();
            return ResponseEntity.ok(dateRequestService.respondToRequest(requestId, actionUpper, user.getEmail()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error responding to request: " + e.getMessage());
        }
    }

    // Edit an existing request (negotiation)
    @PutMapping("/{requestId}/edit")
    public ResponseEntity<?> editRequest(@PathVariable Long requestId,
                                         @RequestBody @Valid DateRequestDto dto) {
        try {
            UserModel user = getCurrentUser();
            return ResponseEntity.ok(dateRequestService.editRequest(requestId, dto, user.getEmail()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error editing request: " + e.getMessage());
        }
    }

    // Get all sent and received requests for the current user
    @GetMapping("/allRequests")
    public ResponseEntity<?> getAllRequests() {
        try {
            UserModel user = getCurrentUser();
            Map<String, Object> response = new HashMap<>();
            response.put("sent", dateRequestService.getSentRequests(user.getEmail()));
            response.put("received", dateRequestService.getReceivedRequests(user.getEmail()));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching date requests: " + e.getMessage());
        }
    }

    // Helper method to get currently authenticated user
    private UserModel getCurrentUser() {
        return (UserModel) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }
}