package ru.nsu.ccfit.databases.matsko.library_fund.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.StorageInfoEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.services.libraries.StorageInfoService;

import java.util.List;

@RestController
@RequestMapping("/api/si")
public class StorageInfoController {

    @Autowired
    private StorageInfoService siService;

    @GetMapping("")
    public ResponseEntity<List<StorageInfoEntity>> getAll() {
        return ResponseEntity.ok(siService.getAll());
    }
}
