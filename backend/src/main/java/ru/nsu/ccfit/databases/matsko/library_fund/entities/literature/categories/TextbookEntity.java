package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Textbooks", schema = "public")
public class TextbookEntity extends BaseLWCategoryEntity {

    @Nonnull
    @Column(name = "subject")
    private String subject;

    @Nonnull
    @Column(name = "complexity_level")
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
