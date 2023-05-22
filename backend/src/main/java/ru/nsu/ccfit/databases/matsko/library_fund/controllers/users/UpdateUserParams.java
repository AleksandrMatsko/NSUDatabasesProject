package ru.nsu.ccfit.databases.matsko.library_fund.controllers.users;

import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserCategoryEntity;

import java.util.Map;

public class UpdateUserParams {
    private Integer userId;
    private String lastName;
    private String firstName;
    private String patronymic;
    private UserCategoryEntity category;
    private Map<String, Object> categoryInfo;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getPatronymic() {
        return patronymic;
    }

    public void setPatronymic(String patronymic) {
        this.patronymic = patronymic;
    }

    public UserCategoryEntity getCategory() {
        return category;
    }

    public void setCategory(UserCategoryEntity category) {
        this.category = category;
    }

    public Map<String, Object> getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(Map<String, Object> categoryInfo) {
        this.categoryInfo = categoryInfo;
    }
}
