package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.librarians;

public class NewLibrarianParams {
    private String lastName;
    private String firstName;
    private String patronymic;
    private Integer hallId;
    private String dateHired;
    private String dateRetired;

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

    public Integer getHallId() {
        return hallId;
    }

    public void setHallId(Integer hallId) {
        this.hallId = hallId;
    }

    public String getDateHired() {
        return dateHired;
    }

    public void setDateHired(String dateHired) {
        this.dateHired = dateHired;
    }

    public String getDateRetired() {
        return dateRetired;
    }

    public void setDateRetired(String dateRetired) {
        this.dateRetired = dateRetired;
    }

    public boolean validate() {
        return !lastName.isEmpty() && !firstName.isEmpty() && (patronymic == null || !patronymic.isEmpty())
                && hallId > 0;
    }
}
