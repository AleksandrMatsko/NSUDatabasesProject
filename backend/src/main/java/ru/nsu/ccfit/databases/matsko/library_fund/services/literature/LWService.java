package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LWCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories.BaseLWCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.*;

import java.util.*;
import java.util.logging.Logger;

@Service
public class LWService {
    private static final Logger logger = Logger.getLogger(LWService.class.getName());

    @Autowired
    private LWRepository lwRepository;

    @Autowired
    private LWCategoryRepository lwCategoryRepository;

    @Autowired
    private AuthorRepository authorRepository;

    @Autowired
    private BaseLWCategoryRepository baseLWCategoryRepository;

    public List<LiteraryWorkEntity> getAll() {
        logger.info(() -> "requesting all literary works");
        List<LiteraryWorkEntity> list = new ArrayList<>(lwRepository.findAll());
        logger.info(() -> "got " + list.size() + " literary works");
        return list;
    }

    public List<LinkedHashMap<String, Object>> getPopular(Integer limit) {
        logger.info(() -> "requesting " + limit + " popular literary works");
        List<LWWithCount> list = new ArrayList<>(lwRepository.findPopularLW(limit));
        logger.info(() -> "got " + list.size() + " records");
        List<LinkedHashMap<String, Object>> res = new ArrayList<>();
        for (LWWithCount info : list) {
            if (info.getLwId() != null) {
                LinkedHashMap<String, Object> param = new LinkedHashMap<>();
                param.put("lw", lwRepository.findById(info.getLwId()));
                if (info.getCount() == null) {
                    param.put("count", 0);
                } else {
                    param.put("count", info.getCount());
                }
                res.add(param);
            }
        }
        return res;
    }

    @Transactional
    public LiteraryWorkEntity add(String lwName, String categoryName, BaseLWCategoryEntity categoryInfo,
                                  List<Integer> authorIds) {
        logger.info(() -> "creating new lw with name: " + lwName);
        LiteraryWorkEntity newLW = new LiteraryWorkEntity();
        newLW.setName(lwName);
        LWCategoryEntity category = lwCategoryRepository.getCategoryByName(categoryName);
        if (category != null && categoryInfo != null) {
            newLW.setCategory(category);
            categoryInfo.setLiteraryWork(newLW);
            newLW.setCategoryInfo(categoryInfo);
        }
        else if (category != null) {
            throw new IllegalStateException("category info for literary work not provided");
        }
        List<AuthorEntity> authors = authorRepository.findAllById(authorIds);
        newLW.setAuthors(new LinkedHashSet<>(authors));
        var res = lwRepository.save(newLW);
        if (categoryInfo != null) {
            baseLWCategoryRepository.save(categoryInfo);
        }
        return res;
    }

    @Transactional
    public LiteraryWorkEntity update(LiteraryWorkEntity literaryWorkEntity) {
        logger.info(() -> "updating lw with id = " + literaryWorkEntity.getLwId());
        if (lwRepository.existsById(literaryWorkEntity.getLwId())) {
            return lwRepository.save(literaryWorkEntity);
        }
        throw new IllegalStateException("no literary work with id = " + literaryWorkEntity.getLwId());
    }
}
