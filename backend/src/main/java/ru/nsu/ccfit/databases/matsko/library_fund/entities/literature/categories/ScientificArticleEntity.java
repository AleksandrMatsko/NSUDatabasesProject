package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

import java.util.Date;

@Entity
@Table(name = "public.ScientificArticles", schema = "public")
public class ScientificArticleEntity extends BaseLWCategoryEntity {

    @JsonView({View.LWView.class})
    @Column(name = "date_issue", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateIssue;

    @Nonnull
    public Date getDateIssue() {
        return dateIssue;
    }

    public void setDateIssue(@Nonnull Date dateIssue) {
        this.dateIssue = dateIssue;
    }
}
