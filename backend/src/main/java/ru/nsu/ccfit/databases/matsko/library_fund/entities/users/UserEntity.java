package ru.nsu.ccfit.databases.matsko.library_fund.entities.users;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.RegistrationJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories.BaseUserCategoryEntity;

import java.util.Set;

@Entity
@Table(name = "public.Users", schema = "public")
public class UserEntity {

    @JsonView({View.UserView.class, View.IJView.class, View.RJView.class})
    @Id
    @Column(name = "user_id", updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    @JsonView({View.UserView.class, View.IJView.class, View.RJView.class})
    @Column(name = "last_name", nullable = false)
    private String lastName;

    @JsonView({View.UserView.class, View.IJView.class, View.RJView.class})
    @Column(name = "first_name", nullable = false)
    private String firstName;

    @JsonView({View.UserView.class, View.IJView.class, View.RJView.class})
    private String patronymic;

    @JsonView({View.UserView.class, View.IJView.class, View.RJView.class})
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category", referencedColumnName = "category_id", foreignKey = @ForeignKey(name = "categories_fk"))
    private UserCategoryEntity category;

    @JsonView({View.UserView.class})
    @OneToOne(mappedBy = "user", fetch = FetchType.EAGER)
    private BaseUserCategoryEntity categoryInfo;

    @OneToOne(mappedBy = "user")
    private RegistrationJournalEntity registration;

    @OneToMany(mappedBy = "user")
    private Set<IssueJournalEntity> issues;

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

    public UserCategoryEntity getCategory() {
        return category;
    }

    public void setCategory(UserCategoryEntity category) {
        this.category = category;
    }

    public BaseUserCategoryEntity getCategoryInfo() {
        return categoryInfo;
    }

    public void setCategoryInfo(BaseUserCategoryEntity categoryInfo) {
        this.categoryInfo = categoryInfo;
    }

    public RegistrationJournalEntity getRegistration() {
        return registration;
    }

    public void setRegistration(RegistrationJournalEntity registration) {
        this.registration = registration;
    }

    public Set<IssueJournalEntity> getIssues() {
        return issues;
    }

    public void setIssues(Set<IssueJournalEntity> issues) {
        this.issues = issues;
    }

}
