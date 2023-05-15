package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.annotation.Nonnull;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;

@Entity
@Table(name = "public.Poems", schema = "public")
public class PoemEntity extends BaseLWCategoryEntity {

    @JsonView({View.LWView.class})
    @Column(name = "rhyming_method", nullable = false)
    private String rhymingMethod;

    @JsonView({View.LWView.class})
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
