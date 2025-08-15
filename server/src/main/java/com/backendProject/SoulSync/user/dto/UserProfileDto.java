package com.backendProject.SoulSync.user.dto;

public class UserProfileDto {
    private Integer id;
    private String name;
    private Integer age;
    private String gender;
    private String bio;
    private String location;
    private String interests;
    private String profileImageUrl;
    private Double height;
    private String sports;
    private String games;
    private String relationshipType; //casual or commitment
    private Boolean goesGym;
    private Boolean shortHair;
    private Boolean wearGlasses;
    private Boolean drink;
    private Boolean smoke;
    public UserProfileDto() {
    }

    public UserProfileDto(Integer id,String name, Integer age, String gender, String bio, String location, String interests, String profileImageUrl, Double height, String sports, String games, String relationshipType, Boolean goesGym, Boolean shortHair, Boolean wearGlasses, Boolean drink, Boolean smoke) {
        this.id=id;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.bio = bio;
        this.location = location;
        this.interests = interests;
        this.profileImageUrl = profileImageUrl;
        this.height = height;
        this.sports = sports;
        this.games = games;
        this.relationshipType = relationshipType;
        this.goesGym = goesGym;
        this.shortHair = shortHair;
        this.wearGlasses = wearGlasses;
        this.drink = drink;
        this.smoke = smoke;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public String getSports() {
        return sports;
    }

    public void setSports(String sports) {
        this.sports = sports;
    }

    public String getGames() {
        return games;
    }

    public void setGames(String games) {
        this.games = games;
    }

    public String getRelationshipType() {
        return relationshipType;
    }

    public void setRelationshipType(String relationshipType) {
        this.relationshipType = relationshipType;
    }

    public Boolean getGoesGym() {
        return goesGym;
    }

    public void setGoesGym(Boolean goesGym) {
        this.goesGym = goesGym;
    }

    public Boolean getShortHair() {
        return shortHair;
    }

    public void setShortHair(Boolean shortHair) {
        this.shortHair = shortHair;
    }

    public Boolean getWearGlasses() {
        return wearGlasses;
    }

    public void setWearGlasses(Boolean wearGlasses) {
        this.wearGlasses = wearGlasses;
    }

    public Boolean getDrink() {
        return drink;
    }

    public void setDrink(Boolean drink) {
        this.drink = drink;
    }

    public Boolean getSmoke() {
        return smoke;
    }

    public void setSmoke(Boolean smoke) {
        this.smoke = smoke;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }

}
