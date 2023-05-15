package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.IssueJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.IJService;

import java.util.List;

@RestController
@RequestMapping("/api/ij")
public class IJController {

    @Autowired
    private IJService ijService;

    @JsonView({View.IJView.class})
    @GetMapping("")
    public ResponseEntity<List<IssueJournalEntity>> getAll() {
        return ResponseEntity.ok(ijService.getAll());
    }
}
