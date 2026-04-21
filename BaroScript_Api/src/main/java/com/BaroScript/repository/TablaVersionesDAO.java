package com.BaroScript.repository;

import com.BaroScript.model.TablaVersiones;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface TablaVersionesDAO extends JpaRepository<TablaVersiones, Integer> {

    // se comprobara cada 120h(5d) si la versión cambió
    // si cambió → popup "¿Descargar actualización?"
    Optional<TablaVersiones> findTopByOrderByVersionIdDesc();
}
