package com.BaroScript.repository;

import com.BaroScript.model.Rol;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface RolDAO extends JpaRepository<Rol, Integer> {

    Optional<Rol> findByNombre(String nombre);

}
