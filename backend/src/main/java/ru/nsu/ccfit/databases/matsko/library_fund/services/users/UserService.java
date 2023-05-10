package ru.nsu.ccfit.databases.matsko.library_fund.services.users;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public List<UserEntity> getAll() {
        List<UserEntity> list = new ArrayList<>();
        for (UserEntity user: userRepository.findAll()) {
            list.add(user);
        }
        return list;
    }

    public UserEntity add(UserEntity userEntity) {
        return userRepository.save(userEntity);
    }
}
