package com.BaroScript.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class HojaInmersionResponseDTO {

    private Integer hojaId;
    private LocalDate fecha;
    private String lugar;
    private String empresa;
    private String finalidad;

    // datos de entrada
    private BigDecimal profundidadMax;
    private Integer tiempoFondo;
    private String mezclaDescompresion;
    private BigDecimal alturaInmersion;

    // Campos calculados desde las tablas de buceo
    private String tPrimeraParada;
    private BigDecimal profundidadTeorica;

    // Paradas excepcionales (solo para inmersiones > 57 mca)
    private Integer parada39;
    private Integer parada36;
    private Integer parada33;

    // Paradas estándar
    private Integer parada30;
    private Integer parada27;
    private Integer parada24;
    private Integer parada21;
    private Integer parada18;
    private Integer parada15;
    private Integer parada12;
    private Integer parada9;
    private Integer parada6;

    private String tiempoTotalAscenso;
    private BigDecimal periodosO2Camara;
    private String grupoInmersion;
    private Boolean esInmersionSucesiva;

    private LocalDateTime createdAt;
    private LocalDateTime syncedAt;

    // buceadores que participaron en la inmersión
    private List<BuceadorResponseDTO> buceadores;

    public HojaInmersionResponseDTO() {}

    public Integer getHojaId() { return hojaId; }
    public void setHojaId(Integer hojaId) { this.hojaId = hojaId; }

    public LocalDate getFecha() { return fecha; }
    public void setFecha(LocalDate fecha) { this.fecha = fecha; }

    public String getLugar() { return lugar; }
    public void setLugar(String lugar) { this.lugar = lugar; }

    public String getEmpresa() { return empresa; }
    public void setEmpresa(String empresa) { this.empresa = empresa; }

    public String getFinalidad() { return finalidad; }
    public void setFinalidad(String finalidad) { this.finalidad = finalidad; }

    public BigDecimal getProfundidadMax() { return profundidadMax; }
    public void setProfundidadMax(BigDecimal profundidadMax) { this.profundidadMax = profundidadMax; }

    public Integer getTiempoFondo() { return tiempoFondo; }
    public void setTiempoFondo(Integer tiempoFondo) { this.tiempoFondo = tiempoFondo; }

    public String getMezclaDescompresion() { return mezclaDescompresion; }
    public void setMezclaDescompresion(String mezclaDescompresion) { this.mezclaDescompresion = mezclaDescompresion; }

    public BigDecimal getAlturaInmersion() { return alturaInmersion; }
    public void setAlturaInmersion(BigDecimal alturaInmersion) { this.alturaInmersion = alturaInmersion; }

    public String gettPrimeraParada() { return tPrimeraParada; }
    public void settPrimeraParada(String tPrimeraParada) { this.tPrimeraParada = tPrimeraParada; }

    public BigDecimal getProfundidadTeorica() { return profundidadTeorica; }
    public void setProfundidadTeorica(BigDecimal profundidadTeorica) { this.profundidadTeorica = profundidadTeorica; }

    public Integer getParada39() { return parada39; }
    public void setParada39(Integer parada39) { this.parada39 = parada39; }

    public Integer getParada36() { return parada36; }
    public void setParada36(Integer parada36) { this.parada36 = parada36; }

    public Integer getParada33() { return parada33; }
    public void setParada33(Integer parada33) { this.parada33 = parada33; }

    public Integer getParada30() { return parada30; }
    public void setParada30(Integer parada30) { this.parada30 = parada30; }

    public Integer getParada27() { return parada27; }
    public void setParada27(Integer parada27) { this.parada27 = parada27; }

    public Integer getParada24() { return parada24; }
    public void setParada24(Integer parada24) { this.parada24 = parada24; }

    public Integer getParada21() { return parada21; }
    public void setParada21(Integer parada21) { this.parada21 = parada21; }

    public Integer getParada18() { return parada18; }
    public void setParada18(Integer parada18) { this.parada18 = parada18; }

    public Integer getParada15() { return parada15; }
    public void setParada15(Integer parada15) { this.parada15 = parada15; }

    public Integer getParada12() { return parada12; }
    public void setParada12(Integer parada12) { this.parada12 = parada12; }

    public Integer getParada9() { return parada9; }
    public void setParada9(Integer parada9) { this.parada9 = parada9; }

    public Integer getParada6() { return parada6; }
    public void setParada6(Integer parada6) { this.parada6 = parada6; }

    public String getTiempoTotalAscenso() { return tiempoTotalAscenso; }
    public void setTiempoTotalAscenso(String tiempoTotalAscenso) { this.tiempoTotalAscenso = tiempoTotalAscenso; }

    public BigDecimal getPeriodosO2Camara() { return periodosO2Camara; }
    public void setPeriodosO2Camara(BigDecimal periodosO2Camara) { this.periodosO2Camara = periodosO2Camara; }

    public String getGrupoInmersion() { return grupoInmersion; }
    public void setGrupoInmersion(String grupoInmersion) { this.grupoInmersion = grupoInmersion; }

    public Boolean getEsInmersionSucesiva() { return esInmersionSucesiva; }
    public void setEsInmersionSucesiva(Boolean esInmersionSucesiva) { this.esInmersionSucesiva = esInmersionSucesiva; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getSyncedAt() { return syncedAt; }
    public void setSyncedAt(LocalDateTime syncedAt) { this.syncedAt = syncedAt; }

    public List<BuceadorResponseDTO> getBuceadores() { return buceadores; }
    public void setBuceadores(List<BuceadorResponseDTO> buceadores) { this.buceadores = buceadores; }
}
