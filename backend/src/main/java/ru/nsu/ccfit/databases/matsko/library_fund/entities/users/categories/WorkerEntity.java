package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Workers", schema = "public")
public class WorkerEntity extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "job", nullable = false)
    private String job;

    @JsonView(View.UserView.class)
    @Column(name = "company", nullable = false)
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
