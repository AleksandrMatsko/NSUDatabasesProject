package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Workers", schema = "public")
public class WorkerEntity extends CategoryEntity {
    @Nonnull
    @Column(name = "job")
    private String job;

    @Nonnull
    @Column(name = "company")
    private String company;

    @Nonnull
    public String getJob() {
        return job;
    }

    public void setJob(@Nonnull String job) {
        this.job = job;
    }

    @Nonnull
    public String getCompany() {
        return company;
    }

    public void setCompany(@Nonnull String company) {
        this.company = company;
    }
}
