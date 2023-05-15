package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "public.Librarians", schema = "public")
public class LibrarianEntity {

    @JsonView({View.LibrarianView.class, View.IJView.class, View.RJView.class})
    @Id
    @Column(name = "librarian_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer librarianId;

    @JsonView({View.LibrarianView.class, View.IJView.class, View.RJView.class})
    @Column(name = "last_name", nullable = false)
    private String lastName;

    @JsonView({View.LibrarianView.class, View.IJView.class, View.RJView.class})
    @Column(name = "first_name", nullable = false)
    private String firstName;

    @JsonView({View.LibrarianView.class, View.IJView.class, View.RJView.class})
    private String patronymic;

    @JsonView({View.LibrarianView.class})
    @Column(name = "date_hired", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateHired;

    @JsonView({View.LibrarianView.class})
    @Column(name = "date_retired")
    @Temporal(TemporalType.DATE)
    private Date dateRetired;

    @JsonView({View.LibrarianView.class})
    @ManyToOne
    @JoinColumn(name="hall_id", referencedColumnName = "hall_id")
    private HallEntity hall;

    @OneToMany(mappedBy = "librarian")
    private Set<RegistrationJournalEntity> registrations;

    @OneToMany(mappedBy = "issuedBy")
    private Set<IssueJournalEntity> issues;

    @OneToMany(mappedBy = "acceptedBy")
    private Set<IssueJournalEntity> accepts;

    public Integer getLibrarianId() {
        return librarianId;
    }

    public void setLibrarianId(Integer librarianId) {
        this.librarianId = librarianId;
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

    public Date getDateHired() {
        return dateHired;
    }

    public void setDateHired(Date dateHired) {
        this.dateHired = dateHired;
    }

    public Date getDateRetired() {
        return dateRetired;
    }

    public void setDateRetired(Date dateRetired) {
        this.dateRetired = dateRetired;
    }

    public HallEntity getHall() {
        return hall;
    }

    public void setHall(HallEntity hall) {
        this.hall = hall;
    }

    public Set<RegistrationJournalEntity> getRegistrations() {
        return registrations;
    }

    public void setRegistrations(Set<RegistrationJournalEntity> registrations) {
        this.registrations = registrations;
    }

    public Set<IssueJournalEntity> getIssues() {
        return issues;
    }

    public void setIssues(Set<IssueJournalEntity> issues) {
        this.issues = issues;
    }

    public Set<IssueJournalEntity> getAccepts() {
        return accepts;
    }

    public void setAccepts(Set<IssueJournalEntity> accepts) {
        this.accepts = accepts;
    }

}
