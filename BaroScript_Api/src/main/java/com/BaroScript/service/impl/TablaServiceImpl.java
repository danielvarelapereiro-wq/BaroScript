package com.BaroScript.service.impl;

import com.BaroScript.dto.response.TablaVersionesResponseDTO;
import com.BaroScript.model.*;
import com.BaroScript.repository.*;
import com.BaroScript.service.TablaService;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

public class TablaServiceImpl implements TablaService {

    private final TablaVersionesDAO tablaVersionesDAO;
    private final TablaIDAO tablaIDAO;
    private final TablaII_IsDAO tablaIIIsDAO;
    private final TablaII_TNRDAO tablaIITnrDAO;
    private final TablaIIIDAO tablaIIIDAO;
    private final TablaIIIExcepDAO tablaIIIExcepDAO;
    private final TablaIVProfundidadDAO tablaIVProfundidadDAO;
    private final TablaIVParadasDAO tablaIVParadasDAO;
    private final TablaVDAO tablaVDAO;
    private final TablaVIDAO tablaVIDAO;
    private final TablaVIIDAO tablaVIIDAO;

    public TablaServiceImpl(TablaVersionesDAO tablaVersionesDAO,
                            TablaIDAO tablaIDAO,
                            TablaII_IsDAO tablaIIIsDAO,
                            TablaII_TNRDAO tablaIITnrDAO,
                            TablaIIIDAO tablaIIIDAO,
                            TablaIIIExcepDAO tablaIIIExcepDAO,
                            TablaIVProfundidadDAO tablaIVProfundidadDAO,
                            TablaIVParadasDAO tablaIVParadasDAO,
                            TablaVDAO tablaVDAO,
                            TablaVIDAO tablaVIDAO,
                            TablaVIIDAO tablaVIIDAO) {
        this.tablaVersionesDAO = tablaVersionesDAO;
        this.tablaIDAO = tablaIDAO;
        this.tablaIIIsDAO = tablaIIIsDAO;
        this.tablaIITnrDAO = tablaIITnrDAO;
        this.tablaIIIDAO = tablaIIIDAO;
        this.tablaIIIExcepDAO = tablaIIIExcepDAO;
        this.tablaIVProfundidadDAO = tablaIVProfundidadDAO;
        this.tablaIVParadasDAO = tablaIVParadasDAO;
        this.tablaVDAO = tablaVDAO;
        this.tablaVIDAO = tablaVIDAO;
        this.tablaVIIDAO = tablaVIIDAO;
    }

    @Override
    public TablaVersionesResponseDTO getVersion() {
        TablaVersiones version = tablaVersionesDAO.findTopByOrderByVersionIdDesc()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                        "No hay versión de tablas en la base de datos"));

        return new TablaVersionesResponseDTO(
                version.getVersionId(),
                version.getUltimaModificacion(),
                version.getVersionTag(),
                version.getDescripcion()
        );
    }

    @Override
    public List<TablaI> getTablaI() {
        return tablaIDAO.findAll();
    }

    @Override
    public List<TablaII_Is> getTablaIIIs() {
        return tablaIIIsDAO.findAll();
    }

    @Override
    public List<TablaII_TNR> getTablaIITnr() {
        return tablaIITnrDAO.findAll();
    }

    @Override
    public List<TablaIII> getTablaIII() {
        return tablaIIIDAO.findAll();
    }

    @Override
    public List<TablaIIIExcep> getTablaIIIExcep() {
        return tablaIIIExcepDAO.findAll();
    }

    @Override
    public List<TablaIVProfundidad> getTablaIVProfundidad() {
        return tablaIVProfundidadDAO.findAll();
    }

    @Override
    public List<TablaIVParadas> getTablaIVParadas() {
        return tablaIVParadasDAO.findAll();
    }

    @Override
    public List<TablaV> getTablaV() {
        return tablaVDAO.findAll();
    }

    @Override
    public List<TablaVI> getTablaVI() {
        return tablaVIDAO.findAll();
    }

    @Override
    public List<TablaVII> getTablaVII() {
        return tablaVIIDAO.findAll();
    }
}
