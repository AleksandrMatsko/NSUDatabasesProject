package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Pensioners", schema = "public")
public class PensionerEntityBaseUser extends BaseUserCategoryEntity {

    @Nonnull
    @Column(name = "discount")
    private Integer discount;

    @Nonnull
    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(@Nonnull Integer discount) {
        this.discount = discount;
    }
}
