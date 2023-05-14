package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Teachers", schema = "public")
public class TeacherEntityBaseUser extends BaseUserCategoryEntity {

    @Column(name = "school", nullable = false)
    private String school;

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
