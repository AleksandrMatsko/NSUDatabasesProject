package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.si;

public class SIParams {
    private Integer bookId;
    private Integer hallId;
    private Integer bookcase;
    private Integer shelf;
    private String availableIssue;
    private Integer durationIssue;
    private String dateReceipt;
    private String dateDispose;

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public Integer getHallId() {
        return hallId;
    }

    public void setHallId(Integer hallId) {
        this.hallId = hallId;
    }

    public Integer getBookcase() {
        return bookcase;
    }

    public void setBookcase(Integer bookcase) {
        this.bookcase = bookcase;
    }

    public Integer getShelf() {
        return shelf;
    }

    public void setShelf(Integer shelf) {
        this.shelf = shelf;
    }

    public String getAvailableIssue() {
        return availableIssue;
    }

    public void setAvailableIssue(String availableIssue) {
        this.availableIssue = availableIssue;
    }

    public Integer getDurationIssue() {
        return durationIssue;
    }

    public void setDurationIssue(Integer durationIssue) {
        this.durationIssue = durationIssue;
    }

    public String getDateReceipt() {
        return dateReceipt;
    }

    public void setDateReceipt(String dateReceipt) {
        this.dateReceipt = dateReceipt;
    }

    public String getDateDispose() {
        return dateDispose;
    }

    public void setDateDispose(String dateDispose) {
        this.dateDispose = dateDispose;
    }
     public boolean validatePlace() {
        return hallId > 0 && bookcase > 0 && shelf > 0;
     }
}
