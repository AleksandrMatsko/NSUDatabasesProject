package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "public.Librarians", schema = "public")
public class LibrarianEntity {

    @Id
    @Column(name = "librarian_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer libraryId;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    private String patronymic;

    @Column(name = "date_hired", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateHired;

    @Column(name = "date_retired")
    @Temporal(TemporalType.DATE)
    private Date dateRetired;

    @ManyToOne
    @JoinColumn(name="hall_id", referencedColumnName = "hall_id")
    @JsonManagedReference
    private HallEntity hall;

    @OneToMany(mappedBy = "librarian")
    @JsonBackReference
    private Set<RegistrationJournalEntity> registrations;

    public Integer getLibraryId() {
        return libraryId;
    }

    public void setLibraryId(Integer libraryId) {
        this.libraryId = libraryId;
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


}
