package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.LiteraryWorkEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.LWService;

import java.util.List;

@RestController
@RequestMapping("/api/lws")
public class LWController {

    @Autowired
    private LWService lwService;

    @GetMapping("")
    public ResponseEntity<List<LiteraryWorkEntity>> getLiteraryWorks() {
        return ResponseEntity.ok(lwService.getAll());
    }
}
