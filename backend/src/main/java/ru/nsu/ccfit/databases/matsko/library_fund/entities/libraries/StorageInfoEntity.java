package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;

import java.util.Date;


@Entity
@Table(name = "public.StorageInfo", schema = "public")
public class StorageInfoEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stored_id")
    private Integer storedId;

    @ManyToOne
    @JoinColumn(name = "hall_id", referencedColumnName = "hall_id")
    @JsonManagedReference
    private HallEntity hall;

    @Column(nullable = false)
    private Integer bookcase;

    @Column(nullable = false)
    private Integer shelf;

    @Column(name = "available_issue", nullable = false)
    private Boolean availableIssue;

    @Column(name = "duration_issue", nullable = false)
    private Integer durationIssue;

    @Column(name = "date_receipt", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateReceipt;

    @Column(name = "date_dispose")
    @Temporal(TemporalType.DATE)
    private Date dateDispose;

    @ManyToOne
    @JoinColumn(name = "book_id", referencedColumnName = "book_id")
    @JsonManagedReference
    private BookEntity book;

    public Integer getStoredId() {
        return storedId;
    }

    public void setStoredId(Integer storedId) {
        this.storedId = storedId;
    }

    public HallEntity getHall() {
        return hall;
    }

    public void setHall(HallEntity hall) {
        this.hall = hall;
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

    public Boolean getAvailableIssue() {
        return availableIssue;
    }

    public void setAvailableIssue(Boolean availableIssue) {
        this.availableIssue = availableIssue;
    }

    public Integer getDurationIssue() {
        return durationIssue;
    }

    public void setDurationIssue(Integer durationIssue) {
        this.durationIssue = durationIssue;
    }

    public Date getDateReceipt() {
        return dateReceipt;
    }

    public void setDateReceipt(Date dateReceipt) {
        this.dateReceipt = dateReceipt;
    }

    public Date getDateDispose() {
        return dateDispose;
    }

    public void setDateDispose(Date dateDispose) {
        this.dateDispose = dateDispose;
    }

    public BookEntity getBook() {
        return book;
    }

    public void setBook(BookEntity book) {
        this.book = book;
    }


}
