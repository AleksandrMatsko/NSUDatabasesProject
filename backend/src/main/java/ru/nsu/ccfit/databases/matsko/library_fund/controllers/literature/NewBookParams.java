package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature;

import java.util.ArrayList;

public class NewBookParams {
    private String name;
    private ArrayList<Integer> literaryWorks;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<Integer> getLiteraryWorks() {
        return literaryWorks;
    }

    public void setLiteraryWorks(ArrayList<Integer> literaryWorks) {
        this.literaryWorks = literaryWorks;
    }
}
