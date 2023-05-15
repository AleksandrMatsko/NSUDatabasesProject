package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Set;

@Entity
@Table(name = "public.LWCategories", schema = "public")
public class LWCategoryEntity {

    @JsonView({View.LWView.class})
    @Id
    @Column(name = "category_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer categoryId;

    @JsonView({View.LWView.class})
    @Column(name = "category_name", nullable = false)
    private String categoryName;

    @Column(name = "table_name", nullable = false)
    @JsonIgnore
    private String tableName;

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
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
