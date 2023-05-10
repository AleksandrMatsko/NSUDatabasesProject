package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.repository.CrudRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

public interface UserRepository extends CrudRepository<UserEntity, Integer> {

}
