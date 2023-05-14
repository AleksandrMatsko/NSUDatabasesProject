package ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "public.Libraries", schema = "public")
public class LibraryEntity {
    @Id
    @Column(name = "library_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer libraryId;

    @Column(name = "district", nullable = false)
    private String district;

    @Column(name = "street", nullable = false)
    private String street;

    @Column(name = "building", nullable = false)
    private String building;

    @Column(name = "name", nullable = false)
    private String name;

    @OneToMany(mappedBy = "library", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<HallEntity> halls;

    @OneToMany(mappedBy = "library")
    @JsonBackReference
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
