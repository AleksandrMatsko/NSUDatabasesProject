package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "public.Halls", schema = "public")
public class HallEntity {

    @Id
    @Column(name = "hall_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer hallId;

    @ManyToOne
    @JoinColumn(name="library_id", referencedColumnName = "library_id")
    @JsonManagedReference
    private LibraryEntity library;

    @OneToMany(mappedBy = "hall", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<LibrarianEntity> librarians;

    @OneToMany(mappedBy = "hall", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<StorageInfoEntity> stored;

    public Integer getHallId() {
        return hallId;
    }

    public void setHallId(Integer hallId) {
        this.hallId = hallId;
    }

    public LibraryEntity getLibrary() {
        return library;
    }

    public void setLibrary(LibraryEntity library) {
        this.library = library;
    }

    public Set<LibrarianEntity> getLibrarians() {
        return librarians;
    }

    public void setLibrarians(Set<LibrarianEntity> librarians) {
        this.librarians = librarians;
    }

    public Set<StorageInfoEntity> getStored() {
        return stored;
    }

    public void setStored(Set<StorageInfoEntity> stored) {
        this.stored = stored;
    }
}
