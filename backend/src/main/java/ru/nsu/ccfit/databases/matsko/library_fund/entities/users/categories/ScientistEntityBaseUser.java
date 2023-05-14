package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Scientists", schema = "public")
public class ScientistEntityBaseUser extends BaseUserCategoryEntity {

    @Nonnull
    @Column(name = "degree")
    private String degree;

    @Nonnull
    public String getDegree() {
        return degree;
    }

    public void setDegree(@Nonnull String degree) {
        this.degree = degree;
    }
}
