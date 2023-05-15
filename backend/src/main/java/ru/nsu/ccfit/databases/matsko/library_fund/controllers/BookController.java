package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import jakarta.websocket.server.PathParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.literature.BookEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.literature.BookService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final String DATE_FORMAT = "yyyy-MM-dd";

    @Autowired
    private BookService bookService;

    @GetMapping("")
    public ResponseEntity<List<BookEntity>> getBooks() {
        return ResponseEntity.ok(bookService.getAll());
    }

    @GetMapping(value = "/from_reg_lib", params = {"user_last_name", "start", "end"})
    public ResponseEntity<List<BookEntity>> getByUserIdDuringPeriodFromRegLib(
            @RequestParam("user_last_name")  String userLastName,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(bookService.getByUserIdAndPeriodFromRegLib(userLastName, startDate, endDate));
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @GetMapping(value = "/not_from_reg_lib", params = {"user_last_name", "start", "end"})
    public ResponseEntity<List<BookEntity>> getByUserIdDuringPeriodNotFromRegLib(
            @RequestParam("user_last_name") String userLastName,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            return ResponseEntity.ok(bookService.getByUserIdAndPeriodNotFromRegLib(userLastName, startDate, endDate));
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @GetMapping(value = "/place", params = {"lib", "hall", "bookcase", "shelf"})
    public ResponseEntity<List<BookEntity>> getByPlace(
            @RequestParam("lib") String lib,
            @RequestParam("hall") Integer hallId,
            @RequestParam("bookcase") Integer bookcase,
            @RequestParam("shelf") Integer shelf) {
        return ResponseEntity.ok(bookService.getByPlace(lib, hallId, bookcase, shelf));
    }

    @GetMapping(value = "/{act}", params = {"start", "end"})
    public ResponseEntity<List<BookEntity>> getBookFlowInfo(
            @PathVariable("act") String act,
            @RequestParam("start") String start,
            @RequestParam("end") String end) {
        SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date startDate = format.parse(start);
            Date endDate = format.parse(end);
            if (startDate.after(endDate)) {
                return ResponseEntity.badRequest().body(null);
            }
            if (act.equalsIgnoreCase("receipt")) {
                return ResponseEntity.ok(bookService.getReceiptDuringPeriod(startDate, endDate));
            }
            else if (act.equalsIgnoreCase("dispose")) {
                return ResponseEntity.ok(bookService.getDisposeDuringPeriod(startDate, endDate));
            }
            return ResponseEntity.badRequest().body(null);
        }
        catch (ParseException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }


    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<BookEntity> addBook(@RequestBody BookEntity book) {
        BookEntity res = bookService.add(book);
        if (res != null) {
            return ResponseEntity.ok(res);
        }
        return ResponseEntity.badRequest().body(res);
    }

}
