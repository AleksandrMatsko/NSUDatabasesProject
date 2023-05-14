package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "public.LWCategories", schema = "public")
public class LWCategoryEntity {
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
    private Set<LiteraryWorkEntity> lwEntities;

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

    public Set<LiteraryWorkEntity> getLwEntities() {
        return lwEntities;
    }

    public void setLwEntities(Set<LiteraryWorkEntity> lwEntities) {
        this.lwEntities = lwEntities;
    }
}
