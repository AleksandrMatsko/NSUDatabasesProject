package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.RegistrationJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.RJService;

import java.util.List;

@RestController
@RequestMapping("/api/rj")
public class RJController {

    @Autowired
    private RJService rjService;

    @GetMapping("")
    public ResponseEntity<List<RegistrationJournalEntity>> getAll() {
        return ResponseEntity.ok(rjService.getAll());
    }
}
