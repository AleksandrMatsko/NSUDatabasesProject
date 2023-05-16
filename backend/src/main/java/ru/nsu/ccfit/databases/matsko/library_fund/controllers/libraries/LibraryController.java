package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibraryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.LibraryService;

import java.util.List;

@RestController
@RequestMapping("/api/libs")
public class LibraryController {

    @Autowired
    private LibraryService libraryService;

    @JsonView(View.LibraryView.class)
    @GetMapping("")
    public ResponseEntity<List<LibraryEntity>> getAll() {
        return ResponseEntity.ok(libraryService.getAll());
    }
}
