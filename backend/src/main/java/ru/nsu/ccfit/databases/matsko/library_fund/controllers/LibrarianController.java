package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.LibrarianService;

import java.util.List;

@RestController
@RequestMapping("/api/librns")
public class LibrarianController {

    @Autowired
    private LibrarianService librarianService;

    @GetMapping("")
    public ResponseEntity<List<LibrarianEntity>> getAll() {
        return ResponseEntity.ok(librarianService.getAll());
    }
}
