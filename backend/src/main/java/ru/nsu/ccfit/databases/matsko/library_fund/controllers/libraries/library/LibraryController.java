package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.library;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
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

    @JsonView(View.LibraryView.class)
    @PostMapping(consumes = "application/json")
    public ResponseEntity<LibraryEntity> add(@RequestBody NewLibraryParams params) {
        if (params.validate()) {
            return ResponseEntity.ok(libraryService.add(
                    params.getName(),
                    params.getDistrict(),
                    params.getStreet(),
                    params.getBuilding(),
                    params.getNumHalls()));
        }
        return ResponseEntity.badRequest().body(null);
    }

    @JsonView({View.LibraryView.class})
    @PutMapping(value = "/{id}", consumes = "application/json")
    public ResponseEntity<LibraryEntity> update(
            @PathVariable("id") Integer id,
            @RequestBody LibraryEntity library) {
        if (id.equals(library.getLibraryId())) {
            return ResponseEntity.ok(libraryService.update(library));
        }
        return ResponseEntity.badRequest().body(null);
    }
}
