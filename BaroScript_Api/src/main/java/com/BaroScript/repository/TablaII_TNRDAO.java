package com.BaroScript.repository;

import com.BaroScript.model.TablaII_TNR;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TablaII_TNRDAO extends JpaRepository<TablaII_TNR, Integer> {

}
