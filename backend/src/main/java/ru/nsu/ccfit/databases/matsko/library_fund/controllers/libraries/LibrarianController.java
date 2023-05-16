package ru.nsu.ccfit.databases.matsko.library_fund.controllers.libraries;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.LibrarianService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

@RestController
@RequestMapping("/api/librns")
public class LibrarianController {

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
}
