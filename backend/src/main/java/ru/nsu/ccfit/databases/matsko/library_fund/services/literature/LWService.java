package ru.nsu.ccfit.databases.matsko.library_fund.services.literature;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.LWRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.literature.LWWithCount;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.logging.Logger;

@Service
public class LWService {
    private static final Logger logger = Logger.getLogger(LWService.class.getName());

    @Autowired
    private LWRepository lwRepository;

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
}
