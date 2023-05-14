package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

@Entity
@Table(name = "public.Students", schema = "public")
public class StudentEntity extends CategoryEntity {

    @Nonnull
    @Column(name = "faculty")
    private String faculty;

    @Nonnull
    @Column(name = "university")
    private String university;

    @Nonnull
    public String getFaculty() {
        return faculty;
    }

    public void setFaculty(@Nonnull String faculty) {
        this.faculty = faculty;
    }

    @Nonnull
    public String getUniversity() {
        return university;
    }

    public void setUniversity(@Nonnull String university) {
        this.university = university;
    }

}
