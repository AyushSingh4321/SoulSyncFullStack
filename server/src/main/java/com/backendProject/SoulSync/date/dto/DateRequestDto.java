package com.backendProject.SoulSync.date.dto;


import jakarta.validation.constraints.NotBlank;

public class DateRequestDto {
    private Integer id;
    @NotBlank(message = "Date is required")
    private String date;
    @NotBlank(message = "Time is required")
    private String time;
    @NotBlank(message = "Venue is required")
    private String venue;
    private String status;

    private int senderId;
    private String senderName;
    private int receiverId;
    private String receiverName;
    private boolean sentByReceiver;

    // Getters and setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public boolean isSentByReceiver() {
        return sentByReceiver;
    }

    public void setSentByReceiver(boolean sentByReceiver) {
        this.sentByReceiver = sentByReceiver;
    }
}

