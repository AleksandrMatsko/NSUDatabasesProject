package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.ij;

public class IJParams {
    private Integer storedId;
    private Integer userId;
    private String dateIssue;
    private String dateReturn;
    private Integer issuedBy;
    private Integer acceptedBy;

    public Integer getStoredId() {
        return storedId;
    }

    public void setStoredId(Integer storedId) {
        this.storedId = storedId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getDateIssue() {
        return dateIssue;
    }

    public void setDateIssue(String dateIssue) {
        this.dateIssue = dateIssue;
    }

    public String getDateReturn() {
        return dateReturn;
    }

    public void setDateReturn(String dateReturn) {
        this.dateReturn = dateReturn;
    }

    public Integer getIssuedBy() {
        return issuedBy;
    }

    public void setIssuedBy(Integer issuedBy) {
        this.issuedBy = issuedBy;
    }

    public Integer getAcceptedBy() {
        return acceptedBy;
    }

    public void setAcceptedBy(Integer acceptedBy) {
        this.acceptedBy = acceptedBy;
    }
}
