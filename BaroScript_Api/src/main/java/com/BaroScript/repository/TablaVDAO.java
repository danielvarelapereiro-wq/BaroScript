package com.BaroScript.repository;

import com.BaroScript.model.TablaV;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaVDAO extends JpaRepository<TablaV, Integer> {

}
