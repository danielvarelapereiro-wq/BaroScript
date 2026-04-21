package com.BaroScript.repository;

import com.BaroScript.model.InmersionBuceador;
import com.BaroScript.model.PkInmersionBuceador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BuceadorDAO extends JpaRepository<InmersionBuceador, PkInmersionBuceador> {

    // Todos los buceadores que participaron en una hoja concreta
    List<InmersionBuceador> findByHojaInmersionHojaId(Integer hojaId);

}
