package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

import java.util.Date;

@Entity
@Table(name = "public.RegistrationJournal", schema = "public")
public class RegistrationJournalEntity {

    @Id
    @Column(name = "user_id", nullable = false, unique = true, updatable = false)
    private Integer userId;

    @Column(name = "registration_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date registrationDate;

    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @JsonManagedReference
    private UserEntity user;

    @ManyToOne
    @JoinColumn(name="librarian_id", referencedColumnName = "librarian_id")
    @JsonManagedReference
    private LibrarianEntity librarian;

    @ManyToOne
    @JoinColumn(name = "library_id", referencedColumnName = "library_id")
    @JsonManagedReference
    private LibraryEntity library;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public LibrarianEntity getLibrarian() {
        return librarian;
    }

    public void setLibrarian(LibrarianEntity librarian) {
        this.librarian = librarian;
    }

    public LibraryEntity getLibrary() {
        return library;
    }

    public void setLibrary(LibraryEntity library) {
        this.library = library;
    }


}
