package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Pupils", schema = "public")
public class PupilEntity extends CategoryEntity {

    @Nonnull
    @Column(name = "school")
    private String school;

    @Nonnull
    public String getSchool() {
        return school;
    }

    public void setSchool(@Nonnull String school) {
        this.school = school;
    }
}
