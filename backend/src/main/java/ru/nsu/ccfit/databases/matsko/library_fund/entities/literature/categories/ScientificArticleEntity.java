package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "public.ScientificArticles", schema = "public")
public class ScientificArticleEntity extends BaseLWCategoryEntity {
    @Nonnull
    @Column(name = "date_issue")
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
