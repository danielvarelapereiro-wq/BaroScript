package com.BaroScript.repository;

import com.BaroScript.model.TablaVI;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaVIDAO extends JpaRepository<TablaVI, Integer> {

}
