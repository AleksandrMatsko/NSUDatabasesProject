package ru.nsu.ccfit.databases.matsko.library_fund.services.users;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserBookPair;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserRepository;

import java.text.SimpleDateFormat;
import java.util.*;
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

    public List<UserEntity> getAllByIds(Iterable<Integer> ids) {
        return new ArrayList<>(userRepository.findAllById(ids));
    }

    public List<UserEntity> getUserByLW(String template) {
        logger.info(() -> "requesting users who borrowed LW with template: " + template);
        List<Integer> list = new ArrayList<>(userRepository.findUsersWithLW(template));
        logger.info(() -> "got " + list.size() + " users");
        return getAllByIds(list);
    }

    public List<UserEntity> getUserByBook(String template) {
        logger.info(() -> "requesting users who borrowed Book with template: " + template);
        List<Integer> list = new ArrayList<>(userRepository.findUsersWithLW(template));
        logger.info(() -> "got " + list.size() + " users");
        return getAllByIds(list);
    }

    public List<LinkedHashMap<String, Object>> getUserAndBookByNameAndPeriod(String template, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting users who borrowed LW with template: " + template + " from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<UserBookPair> list = new ArrayList<>(
                userRepository.findUsersAndBookNameByLWDuringPeriod(template, startDate, endDate));
        List<LinkedHashMap<String, Object>> res = new ArrayList<>();
        for (UserBookPair obj : list) {
            if (obj.getUserId() != null && obj.getBookId() != null) {
                LinkedHashMap<String, Object> info = new LinkedHashMap<>();
                info.put("user", userRepository.findById(obj.getUserId()));
                info.put("book_id", obj.getBookId());
                res.add(info);
            }
        }
        return res;
    }

    public UserEntity add(UserEntity userEntity) {
        return userRepository.save(userEntity);
    }
}
