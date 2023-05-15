package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Pupils", schema = "public")
public class PupilEntityBaseUser extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "school", nullable = false)
    private String school;

    @Nonnull
    public String getSchool() {
        return school;
    }

    public void setSchool(@Nonnull String school) {
        this.school = school;
    }
}
