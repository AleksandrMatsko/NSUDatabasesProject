package ru.nsu.ccfit.databases.matsko.library_fund.entities.users;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "public.UserCategories", schema = "public")
public class UserCategoryEntity {
    @Id
    @Column(name = "category_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer categoryId;

    @Nonnull
    @Column(name = "category_name")
    private String categoryName;

    @Nonnull
    @Column(name = "table_name")
    private String tableName;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<UserEntity> userEntities;


    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    @Nonnull
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(@Nonnull String categoryName) {
        this.categoryName = categoryName;
    }

    @Nonnull
    public String getTableName() {
        return tableName;
    }

    public void setTableName(@Nonnull String tableName) {
        this.tableName = tableName;
    }

    public Set<UserEntity> getUserEntities() {
        return userEntities;
    }

    public void setUserEntities(Set<UserEntity> userEntities) {
        this.userEntities = userEntities;
    }
}
