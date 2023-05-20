package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Teachers", schema = "public")
public class TeacherEntity extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "school", nullable = false)
    private String school;

    @JsonView(View.UserView.class)
    @Column(name = "subject", nullable = false)
    private String subject;

    @Nonnull
    public String getSchool() {
        return school;
    }

    public void setSchool(@Nonnull String school) {
        this.school = school;
    }

    @Nonnull
    public String getSubject() {
        return subject;
    }

    public void setSubject(@Nonnull String subject) {
        this.subject = subject;
    }
}
