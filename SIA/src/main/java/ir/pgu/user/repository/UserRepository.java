
package ir.pgu.user.repository;

import ir.pgu.user.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByStudentNumber(String studentNumber);

    Optional<User> findByPhoneNumber(String phoneNumber);

    boolean existsByStudentNumber(String studentNumber);

    boolean existsByPhoneNumber(String phoneNumber);
}
