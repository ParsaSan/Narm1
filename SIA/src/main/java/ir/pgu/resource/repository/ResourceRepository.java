package ir.pgu.resource.repository;

import ir.pgu.resource.model.Resource;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ResourceRepository extends JpaRepository<Resource, Long>, JpaSpecificationExecutor<Resource> {

    @Override
    @EntityGraph(attributePaths = {"course", "uploader"})
    List<Resource> findAll(Specification<Resource> spec, Sort sort);

    @EntityGraph(attributePaths = {"course", "uploader"})
    Optional<Resource> findWithDetailsById(Long id);
}