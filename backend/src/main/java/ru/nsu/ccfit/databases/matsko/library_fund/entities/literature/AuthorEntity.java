package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Set;

@Entity
@Table(name = "public.Authors", schema = "public")
public class AuthorEntity {

    @JsonView({View.LWView.class})
    @Id
    @Column(name = "author_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer authorId;

    @JsonView({View.LWView.class})
    @Column(name = "last_name", nullable = false)
    private String lastName;

    @JsonView({View.LWView.class})
    @Column(name = "first_name", nullable = false)
    private String firstName;

    @JsonView({View.LWView.class})
    private String patronymic;

    @ManyToMany(mappedBy = "authors")
    private Set<LiteraryWorkEntity> literaryWorks;

    public Integer getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }

    @Nonnull
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(@Nonnull String firstName) {
        this.firstName = firstName;
    }

    @Nonnull
    public String getLastName() {
        return lastName;
    }

    public void setLastName(@Nonnull String lastName) {
        this.lastName = lastName;
    }

    public String getPatronymic() {
        return patronymic;
    }

    public void setPatronymic(String patronymic) {
        this.patronymic = patronymic;
    }
}
