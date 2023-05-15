package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.StorageInfoService;

import java.util.List;

@RestController
@RequestMapping("/api/si")
public class StorageInfoController {

    @Autowired
    private StorageInfoService siService;

    @JsonView(View.SIView.class)
    @GetMapping("")
    public ResponseEntity<List<StorageInfoEntity>> getByParams(
            @RequestParam(value = "lwtmp", required = false) String lwTmp,
            @RequestParam(value = "author", required = false) String authorTmp) {
        if (lwTmp != null && !lwTmp.isEmpty()) {
            return ResponseEntity.ok(siService.getByLW(lwTmp));
        }
        else if (authorTmp != null && !authorTmp.isEmpty()) {
            return ResponseEntity.ok(siService.getByAuthor(authorTmp));
        }
        return ResponseEntity.ok(siService.getAll());
    }

}
