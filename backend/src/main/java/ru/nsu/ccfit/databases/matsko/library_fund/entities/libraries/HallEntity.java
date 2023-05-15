package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Set;

@Entity
@Table(name = "public.Halls", schema = "public")
public class HallEntity {

    @JsonView({View.LibrarianView.class, View.SIView.class, View.LibraryView.class})
    @Id
    @Column(name = "hall_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer hallId;

    @JsonView({View.LibrarianView.class})
    @ManyToOne
    @JoinColumn(name="library_id", referencedColumnName = "library_id")
    private LibraryEntity library;

    @JsonView({View.LibraryView.class})
    @OneToMany(mappedBy = "hall", cascade = CascadeType.ALL)
    private Set<LibrarianEntity> librarians;

    @OneToMany(mappedBy = "hall", cascade = CascadeType.ALL)
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
