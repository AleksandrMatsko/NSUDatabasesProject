package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.si;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.StorageInfoService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/si")
public class StorageInfoController {
    private static final Logger logger = Logger.getLogger(StorageInfoController.class.getName());

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

    @JsonView(View.SIView.class)
    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<StorageInfoEntity> add(@RequestBody SIParams params) {
        if (!params.validatePlace()) {
            return ResponseEntity.badRequest().body(null);
        }
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date dateReceipt = format.parse(params.getDateReceipt());
            Date dateDispose = null;
            if (params.getDateDispose() != null) {
                dateDispose = format.parse(params.getDateDispose());
            }
            return ResponseEntity.ok(siService.add(
                    params.getBookId(),
                    params.getHallId(),
                    params.getBookcase(),
                    params.getShelf(),
                    Boolean.parseBoolean(params.getAvailableIssue()),
                    params.getDurationIssue(),
                    dateReceipt,
                    dateDispose));
        }
        catch (Exception e) {
            logger.warning(e::getMessage);
            return ResponseEntity.badRequest().body(null);
        }
    }

    @JsonView(View.SIView.class)
    @PutMapping(value = "/{id}", consumes = {"application/json"})
    public ResponseEntity<StorageInfoEntity> update(
            @PathVariable("id") Integer id,
            @RequestBody StorageInfoEntity storageInfoEntity) {
        if (id.equals(storageInfoEntity.getStoredId())) {
            return ResponseEntity.ok(siService.update(storageInfoEntity));
        }
        return ResponseEntity.badRequest().body(null);
    }

    @DeleteMapping("")
    public ResponseEntity<Map<String, Object>> delete(@RequestParam("id") Integer id) {
        siService.delete(id);
        return ResponseEntity.ok((Map<String, Object>) (new HashMap<>()).put("res", "stored deleted"));
    }

}
