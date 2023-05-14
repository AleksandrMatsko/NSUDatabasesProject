package ru.nsu.ccfit.databases.matsko.library_fund.services.users;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class UserService {
    private static final Logger logger = Logger.getLogger(UserService.class.getName());

    @Autowired
    private UserRepository userRepository;

    public List<UserEntity> getAll() {
        logger.info(() -> "requesting all users");
        List<UserEntity> list = new ArrayList<>(userRepository.findAll());
        logger.info(() -> "got " + list.size() + " users");
        return list;
    }

    public UserEntity add(UserEntity userEntity) {
        return userRepository.save(userEntity);
    }
}
