package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.users.UserService;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("")
    public ResponseEntity<List<UserEntity>> getUsers() {
        return ResponseEntity.ok(userService.getAll());
    }

}
