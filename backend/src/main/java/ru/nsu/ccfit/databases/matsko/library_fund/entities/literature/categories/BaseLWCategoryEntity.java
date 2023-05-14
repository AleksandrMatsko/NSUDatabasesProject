package ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class BaseLWCategoryEntity {

    @Id
    @Column(name = "lw_id", unique = true, nullable = false, updatable = false)
    @JsonIgnore
    private Integer lwId;

    @OneToOne
    @MapsId
    @JoinColumn(name = "lw_id", referencedColumnName = "lw_id")
    @JsonBackReference
    private LiteraryWorkEntity literaryWork;

    public Integer getLwId() {
        return lwId;
    }

    public void setLwId(Integer lwId) {
        this.lwId = lwId;
    }

    public LiteraryWorkEntity getLiteraryWork() {
        return literaryWork;
    }

    public void setLiteraryWork(LiteraryWorkEntity literaryWork) {
        this.literaryWork = literaryWork;
    }
}
