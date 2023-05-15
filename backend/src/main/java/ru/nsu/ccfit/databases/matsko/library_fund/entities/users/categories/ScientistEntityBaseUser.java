package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Scientists", schema = "public")
public class ScientistEntityBaseUser extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "degree", nullable = false)
    private String degree;

    @Nonnull
    public String getDegree() {
        return degree;
    }

    public void setDegree(@Nonnull String degree) {
        this.degree = degree;
    }
}
