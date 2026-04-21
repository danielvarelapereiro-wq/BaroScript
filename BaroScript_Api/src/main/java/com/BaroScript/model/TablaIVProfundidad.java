package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_IV_profundidad")
public class TablaIVProfundidad {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla4i_id")
    private Integer tabla4iId;

    @Column(name = "profundidad_real", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadReal;

    @Column(name = "altitud_m", nullable = false)
    private Integer altitudM;

    @Column(name = "profundidad_teorica", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadTeorica;

    public TablaIVProfundidad() {}

    public Integer getTabla4iId() { return tabla4iId; }
    public void setTabla4iId(Integer tabla4iId) { this.tabla4iId = tabla4iId; }

    public BigDecimal getProfundidadReal() { return profundidadReal; }
    public void setProfundidadReal(BigDecimal profundidadReal) { this.profundidadReal = profundidadReal; }

    public Integer getAltitudM() { return altitudM; }
    public void setAltitudM(Integer altitudM) { this.altitudM = altitudM; }

    public BigDecimal getProfundidadTeorica() { return profundidadTeorica; }
    public void setProfundidadTeorica(BigDecimal profundidadTeorica) { this.profundidadTeorica = profundidadTeorica; }

    @Override
    public String toString() {
        return "TablaIVProfundidad{" +
                "tabla4iId=" + tabla4iId +
                ", profundidadReal=" + profundidadReal +
                ", altitudM=" + altitudM +
                ", profundidadTeorica=" + profundidadTeorica +
                '}';
    }
}
