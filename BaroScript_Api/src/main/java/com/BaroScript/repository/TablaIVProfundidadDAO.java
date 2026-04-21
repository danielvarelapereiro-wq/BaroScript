package com.BaroScript.repository;

import com.BaroScript.model.TablaIVProfundidad;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaIVProfundidadDAO extends JpaRepository<TablaIVProfundidad, Integer> {

}
