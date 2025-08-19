package com.backendProject.SoulSync.user.dto;



import com.backendProject.SoulSync.enums.UserStatus;

import java.util.Objects;

public class ChatUserDto {
    private String id;
    private String name;
    private UserStatus status;
    private String profileImageUrl;

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public UserStatus getStatus() {
        return status;
    }

    public void setStatus(UserStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ChatUserDto{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", status=" + status +
                ", profileImageUrl='" + profileImageUrl + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        ChatUserDto that = (ChatUserDto) o;
        return Objects.equals(id, that.id) && Objects.equals(name, that.name) && status == that.status && Objects.equals(profileImageUrl, that.profileImageUrl);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, status, profileImageUrl);
    }
}


