package com.BaroScript.repository;

import com.BaroScript.model.TablaIII;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaIIIDAO extends JpaRepository<TablaIII, Integer> {

}
