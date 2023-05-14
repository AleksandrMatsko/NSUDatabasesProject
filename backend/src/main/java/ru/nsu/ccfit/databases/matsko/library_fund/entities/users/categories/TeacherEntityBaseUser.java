package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Teachers", schema = "public")
public class TeacherEntityBaseUser extends BaseUserCategoryEntity {

    @Nonnull
    @Column(name = "school")
    private String school;

    @Nonnull
    @Column(name = "subject")
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
