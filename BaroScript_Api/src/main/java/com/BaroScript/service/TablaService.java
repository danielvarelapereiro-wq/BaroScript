package com.BaroScript.service;

import com.BaroScript.dto.response.TablaVersionesResponseDTO;
import com.BaroScript.model.*;

import java.util.List;

public interface TablaService {

    // Comprobacion de actualizaciones de tablas
    TablaVersionesResponseDTO getVersion();

    // Descarga completa de cada tabla para Room
    List<TablaI> getTablaI();
    List<TablaII_Is>          getTablaIIIs();
    List<TablaII_TNR>         getTablaIITnr();
    List<TablaIII>            getTablaIII();
    List<TablaIIIExcep>       getTablaIIIExcep();
    List<TablaIVProfundidad>  getTablaIVProfundidad();
    List<TablaIVParadas>      getTablaIVParadas();
    List<TablaV>              getTablaV();
    List<TablaVI>             getTablaVI();
    List<TablaVII>            getTablaVII();
}
