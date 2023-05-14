package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "public.Poems", schema = "public")
public class PoemEntity extends BaseLWCategoryEntity {

    @Column(name = "rhyming_method", nullable = false)
    private String rhymingMethod;

    @Column(name = "verse_size", nullable = false)
    private String verseSize;

    @Nonnull
    public String getRhymingMethod() {
        return rhymingMethod;
    }

    public void setRhymingMethod(@Nonnull String rhymingMethod) {
        this.rhymingMethod = rhymingMethod;
    }

    @Nonnull
    public String getVerseSize() {
        return verseSize;
    }

    public void setVerseSize(@Nonnull String verseSize) {
        this.verseSize = verseSize;
    }
}
