package ru.nsu.ccfit.databases.matsko.library_fund.entities.users;

import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

@Entity
@Table(name = "public.Users", schema = "public")
public class UserEntity {
    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    @Nonnull
    @Column(name = "first_name")
    private String firstName;

    @Nonnull
    @Column(name = "last_name")
    private String lastName;

    private String patronymic;

    private Integer category;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
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

    public Integer getCategory() {
        return category;
    }

    public void setCategory(Integer category) {
        this.category = category;
    }
}
