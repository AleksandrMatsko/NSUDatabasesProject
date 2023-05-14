package ru.nsu.ccfit.databases.matsko.library_fund.repositories.users;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.nsu.ccfit.databases.matsko.library_fund.entities.users.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity, Integer> {

}
