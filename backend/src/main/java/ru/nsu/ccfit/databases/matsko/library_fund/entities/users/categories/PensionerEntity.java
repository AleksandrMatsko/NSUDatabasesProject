package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Pensioners", schema = "public")
public class PensionerEntity extends BaseUserCategoryEntity {

    @JsonView(View.UserView.class)
    @Column(name = "discount", nullable = false)
    private Integer discount;

    @Nonnull
    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(@Nonnull Integer discount) {
        this.discount = discount;
    }
}
