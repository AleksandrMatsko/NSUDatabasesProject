package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature.literary_works;

import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LWCategoryEntity;

import java.util.ArrayList;
import java.util.Map;

public class UpdateLWParams {
    private Integer lwId;
    private String name;
    private String categoryName;
    private ArrayList<AuthorEntity> authors;
    private Map<String, Object> categoryInfo;

    public Integer getLwId() {
        return lwId;
    }

    public void setLwId(Integer lwId) {
        this.lwId = lwId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public ArrayList<AuthorEntity> getAuthors() {
        return authors;
    }

    public void setAuthors(ArrayList<AuthorEntity> authors) {
        this.authors = authors;
    }

    public Map<String, Object> getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(Map<String, Object> categoryInfo) {
        this.categoryInfo = categoryInfo;
    }
}
