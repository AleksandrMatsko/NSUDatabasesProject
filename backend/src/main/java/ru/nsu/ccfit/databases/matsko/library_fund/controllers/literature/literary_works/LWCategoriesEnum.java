package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature.literary_works;

import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

public enum LWCategoriesEnum {

    NOVEL("novel") {
        @Override
        public BaseLWCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("numberChapters") && params.containsKey("shortDesc")) {
                NovelEntity novelEntity = new NovelEntity();
                novelEntity.setNumberChapters((Integer) params.get("numberChapters"));
                novelEntity.setShortDesc((String) params.get("shortDesc"));
                return novelEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for novel");

        }
    },

    SCIENTIFIC_ARTICLE("scientific article") {
        @Override
        public BaseLWCategoryEntity getExample(Map<String, Object> params) {
            try {
                if (params.containsKey("dateIssue")) {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    Date dateIssue = format.parse((String) params.get("dateIssue"));
                    ScientificArticleEntity scientificArticleEntity = new ScientificArticleEntity();
                    scientificArticleEntity.setDateIssue(dateIssue);
                    return scientificArticleEntity;
                }
                throw new IllegalStateException("wrong amount of arguments for scientific article");
            }
            catch (ParseException e) {
                throw new RuntimeException(e);
            }
        }
    },

    POEM("poem") {
        @Override
        public BaseLWCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("verseSize") && params.containsKey("rhymingMethod")) {
                PoemEntity poemEntity = new PoemEntity();
                poemEntity.setRhymingMethod((String) params.get("rhymingMethod"));
                poemEntity.setVerseSize((String) params.get("verseSize"));
                return poemEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for poem");
        }
    },

    TEXTBOOK("textbook") {
        @Override
        public BaseLWCategoryEntity getExample(Map<String, Object> params) {
            if (params.containsKey("complexityLevel") && params.containsKey("subject")) {
                TextbookEntity textbookEntity = new TextbookEntity();
                textbookEntity.setComplexityLevel((String) params.get("complexityLevel"));
                textbookEntity.setSubject((String) params.get("subject"));
                return textbookEntity;
            }
            throw new IllegalStateException("wrong amount of arguments for textbook");
        }
    };

    private final String categoryName;

    LWCategoriesEnum(String categoryName) {
        this.categoryName = categoryName.toLowerCase();
    }

    public String getCategoryName() {
        return this.categoryName;
    }


    @Override
    public String toString() {
        return categoryName;
    }

    public abstract BaseLWCategoryEntity getExample(Map<String, Object> params);


}
