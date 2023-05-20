package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature.literary_works;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.categories.BaseLWCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.LWService;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/lws")
public class LWController {
    private static final Logger logger = Logger.getLogger(LWController.class.getName());

    @Autowired
    private LWService lwService;

    @JsonView(View.LWView.class)
    @GetMapping("")
    public ResponseEntity<List<LiteraryWorkEntity>> getLiteraryWorks() {
        return ResponseEntity.ok(lwService.getAll());
    }

    @JsonView(View.LWView.class)
    @GetMapping(value = "/popular", params = {"limit"})
    public ResponseEntity<List<LinkedHashMap<String, Object>>> getPopular(
            @RequestParam("limit") Integer limit) {
        if (limit < 0) {
            return ResponseEntity.badRequest().body(null);
        }
        return ResponseEntity.ok(lwService.getPopular(limit));
    }

    @JsonView(View.LWView.class)
    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<LiteraryWorkEntity> add(@RequestBody NewLWParams params) {
        String lwName = params.getLwName();
        if (lwName == null || lwName.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }
        String category = params.getCategoryName();
        try {
            if (category != null) {
                for (LWCategoriesEnum lwCategory : LWCategoriesEnum.values()) {
                    if (lwCategory.getCategoryName().equals(category)) {
                        BaseLWCategoryEntity lwCategoryEntity = lwCategory.getExample(params.getCategoryInfo());
                        return ResponseEntity.ok(lwService.add(lwName, category, lwCategoryEntity, params.getAuthors()));
                    }
                }
            }
            else {
                return ResponseEntity.ok(lwService.add(lwName, null, null, params.getAuthors()));
            }
            return ResponseEntity.badRequest().body(null);
        }
        catch (Exception e) {
            logger.info(e::getMessage);
            return ResponseEntity.badRequest().body(null);
        }

    }
}
