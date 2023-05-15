package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.AuthorService;

import java.util.List;

@RestController
@RequestMapping("/api/authors")
public class AuthorController {

    @Autowired
    private AuthorService authorService;

    @JsonView(View.AuthorView.class)
    @GetMapping("")
    public ResponseEntity<List<AuthorEntity>> getAll() {
        return ResponseEntity.ok(authorService.getAll());
    }
}
