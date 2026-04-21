package com.BaroScript.repository;

import com.BaroScript.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioDAO extends JpaRepository<Usuario, Integer> {

    Optional<Usuario> findByUserName(String userName);

    // Comprobaciones de duplicado
    boolean existsByUserName(String userName);
    boolean existsByEmail(String email);

}
