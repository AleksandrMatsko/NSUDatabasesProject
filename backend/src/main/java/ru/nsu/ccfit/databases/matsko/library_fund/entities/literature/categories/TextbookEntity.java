package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Textbooks", schema = "public")
public class TextbookEntity extends BaseLWCategoryEntity {

    @JsonView({View.LWView.class})
    @Column(name = "subject", nullable = false)
    private String subject;

    @JsonView({View.LWView.class})
    @Column(name = "complexity_level", nullable = false)
    private String complexityLevel;

    @Nonnull
    public String getComplexityLevel() {
        return complexityLevel;
    }

    public void setComplexityLevel(@Nonnull String complexityLevel) {
        this.complexityLevel = complexityLevel;
    }

    @Nonnull
    public String getSubject() {
        return subject;
    }

    public void setSubject(@Nonnull String subject) {
        this.subject = subject;
    }
}
