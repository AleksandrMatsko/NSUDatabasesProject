package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Novels", schema = "public")
public class NovelEntity extends BaseLWCategoryEntity {

    @JsonView({View.LWView.class})
    @Column(name = "number_chapters", nullable = false)
    private Integer numberChapters;

    @JsonView({View.LWView.class})
    @Column(name = "short_desc", nullable = false)
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
