package ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class CategoryEntity {
    @Id
    @Column(name = "user_id", unique = true)
    private Integer userId;

    @OneToOne
    @MapsId
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", foreignKey = @ForeignKey(name = "Students_fk0"))
    @JsonBackReference
    private UserEntity user;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }
}
