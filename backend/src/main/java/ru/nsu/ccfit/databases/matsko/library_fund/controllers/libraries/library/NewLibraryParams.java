package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.library;

public class NewLibraryParams {
    private String name;
    private String district;
    private String street;
    private String building;
    private Integer numHalls;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public Integer getNumHalls() {
        return numHalls;
    }

    public void setNumHalls(Integer numHalls) {
        this.numHalls = numHalls;
    }

    public boolean validate() {
        return !name.isEmpty() && !district.isEmpty() && !street.isEmpty() && !building.isEmpty() && numHalls > 0;
    }
}
