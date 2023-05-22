package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature.literary_works;

import java.util.ArrayList;
import java.util.Map;

public class NewLWParams {
    private Integer lwId;
    private String lwName;
    private ArrayList<Integer> authors;
    private String categoryName;
    private Map<String, Object> categoryInfo;

    public String getLwName() {
        return lwName;
    }

    public void setLwName(String lwName) {
        this.lwName = lwName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public ArrayList<Integer> getAuthors() {
        return authors;
    }

    public void setAuthors(ArrayList<Integer> authors) {
        this.authors = authors;
    }

    public Map<String, Object> getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(Map<String, Object> categoryInfo) {
        this.categoryInfo = categoryInfo;
    }

    public Integer getLwId() {
        return lwId;
    }

    public void setLwId(Integer lwId) {
        this.lwId = lwId;
    }
}
