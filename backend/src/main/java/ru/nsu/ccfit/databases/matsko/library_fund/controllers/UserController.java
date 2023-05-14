package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.BookService;
import ru.nsu.ccfit.databases.matsko.library_fund.services.users.UserService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private BookService bookService;

    @GetMapping(value = "")
    public ResponseEntity<List<UserEntity>> getByParams(
            @RequestParam(value = "lwtmp", required = false) String lwTemplate,
            @RequestParam(value = "booktmp", required = false) String bookTemplate) {

        if (lwTemplate != null && !lwTemplate.isEmpty()) {
            return ResponseEntity.ok(userService.getUserByLW(lwTemplate));
        }
        else if (bookTemplate != null && !bookTemplate.isEmpty()) {
            return ResponseEntity.ok(userService.getUserByBook(bookTemplate));
        }
        return ResponseEntity.ok(userService.getAll());
    }

    @GetMapping(value = "", params = {"lwtmp", "start", "end"})
    public ResponseEntity<List<LinkedHashMap<String, Object>>> getByLWAndPeriod(
            @RequestParam("lwtmp") String lwTemplate,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            List<LinkedHashMap<String, Object>> info = userService.getUserAndBookByNameAndPeriod(lwTemplate, startDate, endDate);
            for (LinkedHashMap<String, Object> param : info) {
                Integer bookId = (Integer) param.remove("book_id");
                param.put("book", bookService.getById(bookId));
            }
            return ResponseEntity.ok(info);
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }


}
