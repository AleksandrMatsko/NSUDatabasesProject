package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Students", schema = "public")
public class StudentEntity extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "faculty", nullable = false)
    private String faculty;

    @JsonView(View.UserView.class)
    @Column(name = "university", nullable = false)
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
