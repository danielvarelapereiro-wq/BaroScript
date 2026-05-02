package com.BaroScript.repository;

import com.BaroScript.model.Buceador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface BuceadorDAO extends JpaRepository<Buceador, Integer> {

    List<Buceador> findByUsuarioUsuarioId(Integer usuarioId);

}
