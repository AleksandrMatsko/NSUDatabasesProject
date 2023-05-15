package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;

import java.util.Set;

@Entity
@Table(name = "public.Books", schema = "public")
public class BookEntity {

    @JsonView({View.BookView.class, View.IJView.class, View.SIView.class})
    @Id
    @Column(name = "book_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer bookId;

    @JsonView({View.BookView.class, View.IJView.class, View.SIView.class})
    @Column(name = "name", nullable = false)
    private String name;

    @JsonView(View.BookView.class)
    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "public.WorksInBook",
            joinColumns = @JoinColumn(name = "book_id"),
            inverseJoinColumns = @JoinColumn(name = "lw_id"))
    private Set<LiteraryWorkEntity> literaryWorks;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL)
    private Set<StorageInfoEntity> examples;

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<LiteraryWorkEntity> getLiteraryWorks() {
        return literaryWorks;
    }

    public void setLiteraryWorks(Set<LiteraryWorkEntity> literaryWorks) {
        this.literaryWorks = literaryWorks;
    }

    public Set<StorageInfoEntity> getExamples() {
        return examples;
    }

    public void setExamples(Set<StorageInfoEntity> examples) {
        this.examples = examples;
    }
}
