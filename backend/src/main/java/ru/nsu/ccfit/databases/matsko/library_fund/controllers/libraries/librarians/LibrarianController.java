package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries.librarians;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.LibrarianService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/librns")
public class LibrarianController {
    private static final Logger logger = Logger.getLogger(LibrarianController.class.getName());

    @Autowired
    private LibrarianService librarianService;

    @JsonView({View.LibrarianView.class})
    @GetMapping("")
    public ResponseEntity<List<LibrarianEntity>> getAll() {
        return ResponseEntity.ok(librarianService.getAll());
    }

    @JsonView({View.LibrarianView.class})
    @GetMapping(value = "", params = {"lib_name", "hall"})
    public ResponseEntity<List<LibrarianEntity>> getByLibAndHall(
            @RequestParam("lib_name") String libraryName,
            @RequestParam("hall") Integer hallId) {
        return ResponseEntity.ok(librarianService.getByLibraryAndHall(libraryName, hallId));
    }

    @JsonView({View.LibrarianView.class})
    @GetMapping(value = "/report", params = {"start", "end"})
    public ResponseEntity<List<LinkedHashMap<String, Object>>> getReport(
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(librarianService.getWorkReport(startDate, endDate));
        } catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @JsonView({View.LibrarianView.class})
    @PostMapping(consumes = "application/json")
    public ResponseEntity<LibrarianEntity> add(@RequestBody NewLibrarianParams params) {
        if (params.validate()) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date dateHired = format.parse(params.getDateHired());
                Date dateRetired = null;
                if (params.getDateRetired() != null && !params.getDateRetired().isEmpty()) {
                    dateRetired = format.parse(params.getDateRetired());
                }
                if (dateRetired != null && dateRetired.before(dateHired)) {
                    return ResponseEntity.badRequest().body(null);
                }
                return ResponseEntity.ok(librarianService.add(
                        params.getLastName(),
                        params.getFirstName(),
                        params.getPatronymic(),
                        params.getHallId(),
                        dateHired,
                        dateRetired));
            }
            catch (ParseException e) {
                logger.warning(e::getMessage);
                ResponseEntity.badRequest().body(null);
            }
        }
        return ResponseEntity.badRequest().body(null);
    }

    @JsonView({View.LibrarianView.class})
    @PutMapping(value = "/{id}", consumes = "application/json")
    public ResponseEntity<LibrarianEntity> update(
            @PathVariable("id") Integer id,
            @RequestBody LibrarianEntity librarian) {
        if (id.equals(librarian.getLibrarianId())) {
            return ResponseEntity.ok(librarianService.update(librarian));
        }
        return ResponseEntity.badRequest().body(null);
    }
}
