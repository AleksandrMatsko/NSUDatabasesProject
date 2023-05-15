package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Set;

@Entity
@Table(name = "public.Libraries", schema = "public")
public class LibraryEntity {

    @JsonView({View.LibraryView.class, View.LibrarianView.class, View.RJView.class})
    @Id
    @Column(name = "library_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer libraryId;

    @JsonView({View.LibraryView.class})
    @Column(name = "district", nullable = false)
    private String district;

    @JsonView({View.LibraryView.class})
    @Column(name = "street", nullable = false)
    private String street;

    @JsonView({View.LibraryView.class})
    @Column(name = "building", nullable = false)
    private String building;

    @JsonView({View.LibraryView.class, View.LibrarianView.class, View.RJView.class})
    @Column(name = "name", nullable = false)
    private String name;

    @JsonView(View.LibraryView.class)
    @OneToMany(mappedBy = "library", cascade = CascadeType.ALL)
    private Set<HallEntity> halls;

    @OneToMany(mappedBy = "library")
    private Set<RegistrationJournalEntity> registrations;

    public Integer getLibraryId() {
        return libraryId;
    }

    public void setLibraryId(Integer libraryId) {
        this.libraryId = libraryId;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getBuilding() {
        return building;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<HallEntity> getHalls() {
        return halls;
    }

    public void setHalls(Set<HallEntity> halls) {
        this.halls = halls;
    }

    public Set<RegistrationJournalEntity> getRegistrations() {
        return registrations;
    }

    public void setRegistrations(Set<RegistrationJournalEntity> registrations) {
        this.registrations = registrations;
    }


}
