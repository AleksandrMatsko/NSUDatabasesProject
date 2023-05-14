package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

import java.util.Set;

@Entity
@Table(name = "public.LiteraryWorks", schema = "public")
public class LiteraryWorkEntity {
    @Id
    @Column(name = "lw_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer lwId;

    @Nonnull
    @Column(name = "name")
    private String name;

    @ManyToOne
    @JoinColumn(name="category", referencedColumnName = "category_id", foreignKey = @ForeignKey(name = "lw_category_fk"))
    @JsonManagedReference
    private LWCategoryEntity category;

    @ManyToMany(mappedBy = "literaryWorks")
    @JsonBackReference
    private Set<BookEntity> books;

    public Integer getLwId() {
        return lwId;
    }

    public void setLwId(Integer lwId) {
        this.lwId = lwId;
    }

    @Nonnull
    public String getName() {
        return name;
    }

    public void setName(@Nonnull String name) {
        this.name = name;
    }

    public LWCategoryEntity getCategory() {
        return category;
    }

    public void setCategory(LWCategoryEntity category) {
        this.category = category;
    }
}
