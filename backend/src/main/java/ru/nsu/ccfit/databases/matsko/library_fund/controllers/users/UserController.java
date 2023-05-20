package ru.nsu.ccfit.databases.matsko.library_fund.controllers.users;

import com.fasterxml.jackson.annotation.JsonView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.config.View;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories.BaseUserCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.BookService;
import ru.nsu.ccfit.databases.matsko.library_fund.services.users.UserService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private static final Logger logger = Logger.getLogger(UserController.class.getName());

    @Autowired
    private UserService userService;

    @Autowired
    private BookService bookService;

    @JsonView(View.UserView.class)
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

    @JsonView(View.UserView.class)
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
            List<LinkedHashMap<String, Object>> info = userService.getUserAndBookByNameAndPeriod(
                    lwTemplate, startDate, endDate);
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

    @JsonView(View.UserView.class)
    @GetMapping(value = "", params = {"librn_last_name", "start", "end"})
    public ResponseEntity<List<UserEntity>> getByIdAndPeriod(
            @RequestParam("librn_last_name")  String librnLastName,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(userService.getUserByLibrnIdAndPeriod(librnLastName, startDate, endDate));
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @JsonView(View.UserView.class)
    @GetMapping("/overdue")
    public ResponseEntity<List<UserEntity>> getUserOverdue() {
        return ResponseEntity.ok(userService.getUserWithOverdueBook());
    }

    @JsonView(View.UserView.class)
    @GetMapping(value = "/not_visit", params = {"start", "end"})
    public ResponseEntity<List<UserEntity>> getUsersNotVisit(
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(userService.getUserNotVisitDuringPeriod(startDate, endDate));
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @JsonView(View.UserView.class)
    @PostMapping(consumes = "application/json")
    public ResponseEntity<UserEntity> add(@RequestBody UserParams params) {
        if (!params.validateNames()) {
            return ResponseEntity.badRequest().body(null);
        }
        String category = params.getCategoryName();
        try {
            if (category != null) {
                for (UserCategoryEnum userCategory : UserCategoryEnum.values()) {
                    if (userCategory.getCategoryName().equals(category)) {
                        BaseUserCategoryEntity userCategoryEntity = userCategory.getExample(params.getCategoryInfo());
                        return ResponseEntity.ok(userService.register(
                                params.getLastName(),
                                params.getFirstName(),
                                params.getPatronymic(),
                                params.getCategoryName(),
                                userCategoryEntity,
                                params.getLibrarianId()));
                    }
                }
            }
            else {
                return ResponseEntity.ok(userService.register(
                        params.getLastName(),
                        params.getFirstName(),
                        params.getPatronymic(),
                        null,
                        null,
                        params.getLibrarianId()));
            }
            return ResponseEntity.badRequest().body(null);
        }
        catch (Exception e) {
            logger.warning(e::getMessage);
            return ResponseEntity.badRequest().body(null);
        }

    }
}
