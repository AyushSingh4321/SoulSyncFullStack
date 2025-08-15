package com.backendProject.SoulSync.date.service;

import com.backendProject.SoulSync.date.repo.DateRequestRepo;
import com.backendProject.SoulSync.date.dto.DateRequestDto;
import com.backendProject.SoulSync.date.model.DateRequestModel;
import com.backendProject.SoulSync.enums.DateRequestStatus;
import com.backendProject.SoulSync.user.model.UserModel;
import com.backendProject.SoulSync.user.repo.UserRepo;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DateRequestService {

    @Autowired
    private DateRequestRepo repo;

    @Autowired
    private UserRepo userRepo;

    // Send a new request after deleting existing mutual request if any
    @Transactional
    public DateRequestModel sendRequest(String senderEmail, int receiverId, DateRequestDto dto) {
        UserModel sender = userRepo.findByEmail(senderEmail).orElseThrow(() -> new RuntimeException("Sender not found"));
        UserModel receiver = userRepo.findById(receiverId).orElseThrow(() -> new RuntimeException("Receiver not found"));

        Optional<DateRequestModel> existing = repo.findPendingRequestBetween(sender, receiver);
        if (existing.isPresent()) {
            throw new RuntimeException("Pending request already exists between users. Use edit instead.");
        }

        DateRequestModel request = new DateRequestModel();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setDate(LocalDate.parse(dto.getDate()));
        request.setTime(LocalTime.parse(dto.getTime()));
        request.setVenue(dto.getVenue());
        request.setStatus(DateRequestStatus.PENDING);
        request.setSentByReceiver(false);

        return repo.save(request);
    }

    // Accept or reject a date request
    public DateRequestModel respondToRequest(Long requestId, String action, String email) {
        DateRequestModel request = repo.findById(requestId).orElseThrow(() -> new RuntimeException("Request not found"));

        if (!isParticipant(request, email)) {
            throw new RuntimeException("Unauthorized");
        }

        if (request.getStatus() != DateRequestStatus.PENDING) {
            throw new RuntimeException("Request already finalized");
        }

        if (action.equalsIgnoreCase("accept")) {
            request.setStatus(DateRequestStatus.ACCEPTED);
        } else if (action.equalsIgnoreCase("reject")) {
            request.setStatus(DateRequestStatus.REJECTED);
        } else {
            throw new IllegalArgumentException("Invalid action. Must be 'accept' or 'reject'");
        }

        return repo.save(request);
    }

    // Edit the existing request (can be done by either sender or receiver)
    public DateRequestModel editRequest(Long requestId, DateRequestDto dto, String email) {
        DateRequestModel request = repo.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Request not found"));

        if (request.getStatus() != DateRequestStatus.PENDING) {
            throw new RuntimeException("Cannot edit a finalized request");
        }

        if (!isParticipant(request,email)) {
            throw new RuntimeException("You are not a participant in this request");
        }

        // Update values
        request.setDate(LocalDate.parse(dto.getDate()));
        request.setTime(LocalTime.parse(dto.getTime()));
        request.setVenue(dto.getVenue());

        // Toggle who edited last
        request.setSentByReceiver(request.getReceiver().getEmail().equals(email));

        return repo.save(request);
    }


    // Fetch all sent and received requests separately
    public List<DateRequestDto> getSentRequests(String email) {
        UserModel user = userRepo.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        List<DateRequestModel> sentRequests = repo.findBySender(user);
        return sentRequests.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    public List<DateRequestDto> getReceivedRequests(String email) {
        UserModel user = userRepo.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        List<DateRequestModel> receivedRequests = repo.findByReceiver(user);
        return receivedRequests.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    // Utility method to map entity to DTO
    private DateRequestDto convertToDto(DateRequestModel model) {
        DateRequestDto dto = new DateRequestDto();

        dto.setId(model.getId());
        dto.setDate(model.getDate().toString());
        dto.setTime(model.getTime().toString());
        dto.setVenue(model.getVenue());
        dto.setStatus(model.getStatus().toString());
        dto.setSentByReceiver(model.isSentByReceiver());

        dto.setSenderId(model.getSender().getId());
        dto.setSenderName(model.getSender().getName());
        dto.setReceiverId(model.getReceiver().getId());
        dto.setReceiverName(model.getReceiver().getName());

        return dto;
    }

    // Helper method to check if email belongs to sender or receiver
    private boolean isParticipant(DateRequestModel request, String email) {
        return request.getSender().getEmail().equals(email) ||
                request.getReceiver().getEmail().equals(email);
    }
}
