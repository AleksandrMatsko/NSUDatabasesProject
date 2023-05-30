package ru.nsu.ccfit.databases.matsko.library_fund.services.users;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.LibrarianEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.libraries.RegistrationJournalEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.categories.BaseUserCategoryEntity;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.LibrarianRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.libraries.RJRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.BaseUserCategoryRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserBookPair;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserCategoryRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.repositories.users.UserRepository;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.logging.Logger;

@Service
public class UserService {
    private final String USER_PLURAL = " users";
    private static final Logger logger = Logger.getLogger(UserService.class.getName());

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserCategoryRepository userCategoryRepository;

    @Autowired
    private LibrarianRepository librarianRepository;

    @Autowired
    private RJRepository rjRepository;

    @Autowired
    private BaseUserCategoryRepository baseUserCategoryRepository;

    public List<UserEntity> getAll() {
        logger.info(() -> "requesting all users");
        List<UserEntity> list = new ArrayList<>(userRepository.findAll());
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return list;
    }

    public List<UserEntity> getAllByIds(Iterable<Integer> ids) {
        return new ArrayList<>(userRepository.findAllById(ids));
    }

    public List<UserEntity> getUserByLW(String template) {
        logger.info(() -> "requesting users who borrowed LW with template: " + template);
        List<Integer> list = new ArrayList<>(userRepository.findUsersWithLW(template));
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return getAllByIds(list);
    }

    public List<UserEntity> getUserByBook(String template) {
        logger.info(() -> "requesting users who borrowed Book with template: " + template);
        List<Integer> list = new ArrayList<>(userRepository.findUsersWithLW(template));
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return getAllByIds(list);
    }

    public List<LinkedHashMap<String, Object>> getUserAndBookByNameAndPeriod(String template, Date startDate,
                                                                             Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting users who borrowed LW with template: " + template + " from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<UserBookPair> list = new ArrayList<>(
                userRepository.findUsersAndBookNameByLWDuringPeriod(template, startDate, endDate));
        logger.info(() -> "got " + list.size() + " records");
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

    public List<UserEntity> getUserByLibrnIdAndPeriod(String librnLastName, Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting users who was serviced by librarian " + librnLastName + " from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(userRepository.findUsersByLibrnIdAndPeriod(librnLastName, startDate,endDate));
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return new ArrayList<>(userRepository.findAllById(list));
    }

    public List<UserEntity> getUserWithOverdueBook() {
        logger.info(() -> "requesting users with overdue books");
        List<Integer> list = new ArrayList<>(userRepository.findUsersWithOverdueBooks());
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return new ArrayList<>(userRepository.findAllById(list));
    }

    public List<UserEntity> getUserNotVisitDuringPeriod(Date startDate, Date endDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        logger.info(() -> "requesting users who hadn't visited library from " +
                format.format(startDate) + " to " + format.format(endDate));
        List<Integer> list = new ArrayList<>(userRepository.findUsersNotVisitDuringPeriod(startDate, endDate));
        logger.info(() -> "got " + list.size() + USER_PLURAL);
        return new ArrayList<>(userRepository.findAllById(list));
    }

    @Transactional
    public UserEntity register(String lastName, String firstName, String patronymic, String categoryName,
                               BaseUserCategoryEntity categoryInfo, Integer librarianId) throws ParseException {
        logger.info("adding new user");
        LibrarianEntity librarian = librarianRepository.findById(librarianId).orElseThrow(
                () -> new IllegalStateException("existing librarian required to register user"));
        UserEntity userEntity = new UserEntity();
        userEntity.setLastName(lastName);
        userEntity.setFirstName(firstName);
        userEntity.setPatronymic(patronymic);
        UserCategoryEntity category = userCategoryRepository.getCategoryByName(categoryName);
        if (category != null && categoryInfo != null) {
            userEntity.setCategory(category);
            categoryInfo.setUser(userEntity);
            userEntity.setCategoryInfo(categoryInfo);
        }
        else if (category != null) {
            throw new IllegalStateException("category info for user not provided");
        }
        RegistrationJournalEntity registrationJournalEntity = new RegistrationJournalEntity();
        registrationJournalEntity.setUser(userEntity);
        userEntity.setRegistration(registrationJournalEntity);
        registrationJournalEntity.setLibrarian(librarian);
        registrationJournalEntity.setLibrary(librarian.getHall().getLibrary());
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date registrationDate = format.parse(LocalDate.now().toString());
        registrationJournalEntity.setRegistrationDate(registrationDate);
        UserEntity res = userRepository.save(userEntity);
        rjRepository.save(registrationJournalEntity);
        if (categoryInfo != null) {
            baseUserCategoryRepository.save(categoryInfo);
        }
        return res;
    }

    @Transactional
    public UserEntity update(UserEntity newUser, String categoryName, BaseUserCategoryEntity categoryInfo) {
        logger.info(() -> "updating user with id = " + newUser.getUserId());
        var oldUser = userRepository.findById(newUser.getUserId());
        if (oldUser.isPresent()) {
            if (categoryName != null) {
                UserCategoryEntity category = userCategoryRepository.getCategoryByName(categoryName);
                newUser.setCategory(category);
                categoryInfo.setUserId(newUser.getUserId());
                newUser.setCategoryInfo(categoryInfo);
                categoryInfo.setUser(newUser);
                baseUserCategoryRepository.save(categoryInfo);
            }
            else if (oldUser.get().getCategory() != null) {
                baseUserCategoryRepository.deleteById(oldUser.get().getUserId());
                newUser.setCategory(null);
            }
            return userRepository.save(newUser);
        }
        throw new IllegalStateException("user with id = " + newUser.getUserId() + " not found to update");
    }

    @Transactional
    public void delete(Integer id) {
        logger.info(() -> "deleting user with id: " + id);
        userRepository.deleteUserById(id);
    }
}
