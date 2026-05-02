package com.BaroScript.dto.request;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class HojaInmersionRequestDTO {

    // datos de la inmersión
    private LocalDate fecha;
    private String lugar;
    private String empresa;
    private String finalidad;

    // con estos se consulta la Tabla III
    private BigDecimal profundidadMax;
    private Integer tiempoFondo;
    private String mezclaDescompresion;  // AIRE / AIRE_O2 / DSO2
    private BigDecimal alturaInmersion;  // 0 si es a nivel del mar

    // IDs de los buceadores que participan en la inmersión
    // selecciona de los buceadores registrados
    private List<Integer> buceadorIds;

    // ID del buceador jefe de equipo (puede ser null)
    private Integer jefeEquipoId;

    public HojaInmersionRequestDTO() {}

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

    public List<Integer> getBuceadorIds() { return buceadorIds; }
    public void setBuceadorIds(List<Integer> buceadorIds) { this.buceadorIds = buceadorIds; }

    public Integer getJefeEquipoId() { return jefeEquipoId; }
    public void setJefeEquipoId(Integer jefeEquipoId) { this.jefeEquipoId = jefeEquipoId; }
}
