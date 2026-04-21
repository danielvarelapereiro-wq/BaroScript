package com.BaroScript.repository;

import com.BaroScript.model.TablaIVParadas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaIVParadasDAO extends JpaRepository<TablaIVParadas, Integer> {

}
