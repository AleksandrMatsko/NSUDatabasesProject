package ru.nsu.ccfit.databases.matsko.library_fund.controllers.users;

import java.util.Map;

public class UserParams {
    private String lastName;
    private String firstName;
    private String patronymic;
    private String categoryName;
    private Map<String, Object> categoryInfo;
    private Integer librarianId;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPatronymic() {
        return patronymic;
    }

    public void setPatronymic(String patronymic) {
        this.patronymic = patronymic;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Map<String, Object> getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(Map<String, Object> categoryInfo) {
        this.categoryInfo = categoryInfo;
    }

    public boolean validateNames() {
        return !firstName.isEmpty() && !lastName.isEmpty() && (patronymic == null || !patronymic.isEmpty());
    }

    public Integer getLibrarianId() {
        return librarianId;
    }

    public void setLibrarianId(Integer librarianId) {
        this.librarianId = librarianId;
    }
}
