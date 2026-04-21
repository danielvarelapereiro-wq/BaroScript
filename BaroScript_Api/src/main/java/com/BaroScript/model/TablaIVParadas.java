package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_IV_paradas")
public class TablaIVParadas {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla4p_id")
    private Integer tabla4pId;

    @Column(name = "profundidad_teorica_parada", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadTeoricaParada;

    @Column(name = "altitud_m", nullable = false)
    private Integer altitudM;

    @Column(name = "profundidad_real_parada", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadRealParada;

    public TablaIVParadas() {}

    public Integer getTabla4pId() { return tabla4pId; }
    public void setTabla4pId(Integer tabla4pId) { this.tabla4pId = tabla4pId; }

    public BigDecimal getProfundidadTeoricaParada() { return profundidadTeoricaParada; }
    public void setProfundidadTeoricaParada(BigDecimal v) { this.profundidadTeoricaParada = v; }

    public Integer getAltitudM() { return altitudM; }
    public void setAltitudM(Integer altitudM) { this.altitudM = altitudM; }

    public BigDecimal getProfundidadRealParada() { return profundidadRealParada; }
    public void setProfundidadRealParada(BigDecimal v) { this.profundidadRealParada = v; }

    @Override
    public String toString() {
        return "TablaIVParadas{" +
                "tabla4pId=" + tabla4pId +
                ", profundidadTeoricaParada=" + profundidadTeoricaParada +
                ", altitudM=" + altitudM +
                ", profundidadRealParada=" + profundidadRealParada +
                '}';
    }
}
