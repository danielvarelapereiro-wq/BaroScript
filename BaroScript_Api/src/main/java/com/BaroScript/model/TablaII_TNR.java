package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_II_tnr")
public class TablaII_TNR {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla2tnr_id")
    private Integer tabla2tnrId;

    @Column(name = "grupo_is_final", nullable = false, length = 1)
    private String grupoIsFinal;

    @Column(name = "profundidad_sucesiva", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadSucesiva;

    @Column(name = "tnr_minutos", nullable = false)
    private Integer tnrMinutos;

    public TablaII_TNR() {}

    public Integer getTabla2tnrId() { return tabla2tnrId; }
    public void setTabla2tnrId(Integer tabla2tnrId) { this.tabla2tnrId = tabla2tnrId; }

    public String getGrupoIsFinal() { return grupoIsFinal; }
    public void setGrupoIsFinal(String grupoIsFinal) { this.grupoIsFinal = grupoIsFinal; }

    public BigDecimal getProfundidadSucesiva() { return profundidadSucesiva; }
    public void setProfundidadSucesiva(BigDecimal profundidadSucesiva) { this.profundidadSucesiva = profundidadSucesiva; }

    public Integer getTnrMinutos() { return tnrMinutos; }
    public void setTnrMinutos(Integer tnrMinutos) { this.tnrMinutos = tnrMinutos; }

    @Override
    public String toString() {
        return "TablaII_TNR{" +
                "tabla2tnrId=" + tabla2tnrId +
                ", grupoIsFinal='" + grupoIsFinal + '\'' +
                ", profundidadSucesiva=" + profundidadSucesiva +
                ", tnrMinutos=" + tnrMinutos +
                '}';
    }
}
