package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.ij;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.IJService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/ij")
public class IJController {
    private static final Logger logger = Logger.getLogger(IJController.class.getName());

    @Autowired
    private IJService ijService;

    @JsonView({View.IJView.class})
    @GetMapping("")
    public ResponseEntity<List<IssueJournalEntity>> getAll() {
        return ResponseEntity.ok(ijService.getAll());
    }

    @JsonView({View.IJView.class})
    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<IssueJournalEntity> add(@RequestBody IJParams ijParams) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date dateIssue = format.parse(ijParams.getDateIssue());
            Date dateReturn = null;
            Integer acceptedBy = null;
            if (ijParams.getDateReturn() != null && ijParams.getAcceptedBy() != null) {
                dateReturn = format.parse(ijParams.getDateReturn());
                acceptedBy = ijParams.getAcceptedBy();
            }
            return ResponseEntity.ok(ijService.add(
                    ijParams.getStoredId(),
                    ijParams.getUserId(),
                    dateIssue,
                    dateReturn,
                    ijParams.getIssuedBy(),
                    acceptedBy));
        }
        catch (Exception e) {
            logger.warning(e::getMessage);
            return ResponseEntity.badRequest().body(null);
        }
    }

    @JsonView({View.IJView.class})
    @PutMapping(value = "/{id}", consumes = {"application/json"})
    public ResponseEntity<IssueJournalEntity> update(
            @PathVariable("id") Integer id,
            @RequestBody IssueJournalEntity issueJournalEntity) {
        if (id.equals(issueJournalEntity.getIssueId())) {
            return ResponseEntity.ok(ijService.update(issueJournalEntity));
        }
        return ResponseEntity.badRequest().body(null);
    }


    @DeleteMapping("")
    public ResponseEntity<Map<String, Object>> delete(@RequestParam("id") Integer id) {
        ijService.delete(id);
        return ResponseEntity.ok((Map<String, Object>) (new HashMap<>()).put("res", "issue deleted"));
    }
}
