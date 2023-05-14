package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

import java.util.Date;

@Entity
@Table(name = "public.IssueJournal", schema = "public")
public class IssueJournalEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "issue_id")
    private Integer issueId;

    @ManyToOne
    @JoinColumn(name = "stored_id", referencedColumnName = "stored_id")
    @JsonManagedReference
    private StorageInfoEntity stored;

    @Column(name = "date_issue", nullable = false, updatable = false)
    @Temporal(TemporalType.DATE)
    private Date dateIssue;

    @Column(name = "date_return")
    @Temporal(TemporalType.DATE)
    private Date dateReturn;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @JsonManagedReference
    private UserEntity user;

    @ManyToOne
    @JoinColumn(name = "issued_by_lbrn", referencedColumnName = "librarian_id")
    @JsonManagedReference
    private LibrarianEntity issuedBy;

    @ManyToOne
    @JoinColumn(name = "accepted_by_lbrn", referencedColumnName = "librarian_id")
    @JsonManagedReference
    private LibrarianEntity acceptedBy;

    public Integer getIssueId() {
        return issueId;
    }

    public void setIssueId(Integer issueId) {
        this.issueId = issueId;
    }

    public StorageInfoEntity getStored() {
        return stored;
    }

    public void setStored(StorageInfoEntity stored) {
        this.stored = stored;
    }

    public Date getDateIssue() {
        return dateIssue;
    }

    public void setDateIssue(Date dateIssue) {
        this.dateIssue = dateIssue;
    }

    public Date getDateReturn() {
        return dateReturn;
    }

    public void setDateReturn(Date dateReturn) {
        this.dateReturn = dateReturn;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public LibrarianEntity getIssuedBy() {
        return issuedBy;
    }

    public void setIssuedBy(LibrarianEntity issuedBy) {
        this.issuedBy = issuedBy;
    }

    public LibrarianEntity getAcceptedBy() {
        return acceptedBy;
    }

    public void setAcceptedBy(LibrarianEntity acceptedBy) {
        this.acceptedBy = acceptedBy;
    }
}