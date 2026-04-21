package com.BaroScript.repository;

import com.BaroScript.model.TablaI;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaIDAO extends JpaRepository<TablaI, Integer> {

}
