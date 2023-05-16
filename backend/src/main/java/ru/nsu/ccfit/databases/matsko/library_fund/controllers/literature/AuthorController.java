package ru.nsu.ccfit.databases.matsko.library_fund.controllers.literature;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.AuthorEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.AuthorService;

import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/authors")
public class AuthorController {
    private static final Logger logger = Logger.getLogger(AuthorController.class.getName());

    @Autowired
    private AuthorService authorService;

    @JsonView(View.AuthorView.class)
    @GetMapping("")
    public ResponseEntity<List<AuthorEntity>> getAll() {
        return ResponseEntity.ok(authorService.getAll());
    }

    @JsonView(View.AuthorView.class)
    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<AuthorEntity> addAuthor(@RequestBody NewAuthorParams params) {
        try {
            String lastName = params.getLastName();
            String firstName = params.getFirstName();
            String patronymic = params.getPatronymic();
            if (lastName.isEmpty() || firstName.isEmpty() || (patronymic != null && patronymic.isEmpty())) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(authorService.addAuthor(lastName, firstName, patronymic));
        }
        catch (Exception e) {
            logger.warning(e::getMessage);
            return ResponseEntity.badRequest().body(null);
        }
    }

}
