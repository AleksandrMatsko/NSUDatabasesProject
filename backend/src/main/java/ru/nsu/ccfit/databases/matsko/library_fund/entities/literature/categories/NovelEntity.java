package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Novels", schema = "public")
public class NovelEntity extends BaseLWCategoryEntity {
    @Nonnull
    @Column(name = "number_chapters")
    private Integer numberChapters;

    @Nonnull
    @Column(name = "short_desc")
    private String shortDesc;

    @Nonnull
    public Integer getNumberChapters() {
        return numberChapters;
    }

    public void setNumberChapters(@Nonnull Integer numberChapters) {
        this.numberChapters = numberChapters;
    }

    @Nonnull
    public String getShortDesc() {
        return shortDesc;
    }

    public void setShortDesc(@Nonnull String shortDesc) {
        this.shortDesc = shortDesc;
    }
}
