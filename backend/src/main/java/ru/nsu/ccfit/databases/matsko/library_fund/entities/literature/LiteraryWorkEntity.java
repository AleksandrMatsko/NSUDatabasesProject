package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories.BaseLWCategoryEntity;

import java.util.Set;

@Entity
@Table(name = "public.LiteraryWorks", schema = "public")
public class LiteraryWorkEntity {
    @Id
    @Column(name = "lw_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer lwId;

    @Column(name = "name", nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name="category", referencedColumnName = "category_id", foreignKey = @ForeignKey(name = "lw_category_fk"))
    @JsonManagedReference
    private LWCategoryEntity category;

    @OneToOne(mappedBy = "literaryWork", cascade = CascadeType.ALL)
    @JsonManagedReference
    private BaseLWCategoryEntity categoryInfo;

    @ManyToMany(mappedBy = "literaryWorks")
    @JsonBackReference
    private Set<BookEntity> books;

    @ManyToMany
    @JoinTable(name = "public.AuthorsWorks",
            joinColumns = @JoinColumn(name = "lw_id"),
            inverseJoinColumns = @JoinColumn(name = "author_id"))
    @JsonManagedReference
    private Set<AuthorEntity> authors;

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

    public BaseLWCategoryEntity getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(BaseLWCategoryEntity categoryInfo) {
        this.categoryInfo = categoryInfo;
    }

    public Set<BookEntity> getBooks() {
        return books;
    }

    public void setBooks(Set<BookEntity> books) {
        this.books = books;
    }

    public Set<AuthorEntity> getAuthors() {
        return authors;
    }

    public void setAuthors(Set<AuthorEntity> authors) {
        this.authors = authors;
    }
}
