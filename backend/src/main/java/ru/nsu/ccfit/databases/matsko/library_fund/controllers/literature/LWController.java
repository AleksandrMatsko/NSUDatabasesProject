package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.LWService;

import java.util.LinkedHashMap;
import java.util.List;

@RestController
@RequestMapping("/api/lws")
public class LWController {

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
}
