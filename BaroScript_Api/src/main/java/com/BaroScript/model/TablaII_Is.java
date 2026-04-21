package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_II_is")
public class TablaII_Is {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla2is_id")
    private Integer tabla2isId;

    @Column(name = "grupo_is_inicial", nullable = false, length = 1)
    private String grupoIsInicial;

    @Column(name = "intervalo_min_min", nullable = false)
    private Integer intervaloMinMin;

    @Column(name = "intervalo_max_min")
    private Integer intervaloMaxMin;

    @Column(name = "grupo_is_final", nullable = false, length = 1)
    private String grupoIsFinal;

    public TablaII_Is() {}

    public Integer getTabla2isId() { return tabla2isId; }
    public void setTabla2isId(Integer tabla2isId) { this.tabla2isId = tabla2isId; }

    public String getGrupoIsInicial() { return grupoIsInicial; }
    public void setGrupoIsInicial(String grupoIsInicial) { this.grupoIsInicial = grupoIsInicial; }

    public Integer getIntervaloMinMin() { return intervaloMinMin; }
    public void setIntervaloMinMin(Integer intervaloMinMin) { this.intervaloMinMin = intervaloMinMin; }

    public Integer getIntervaloMaxMin() { return intervaloMaxMin; }
    public void setIntervaloMaxMin(Integer intervaloMaxMin) { this.intervaloMaxMin = intervaloMaxMin; }

    public String getGrupoIsFinal() { return grupoIsFinal; }
    public void setGrupoIsFinal(String grupoIsFinal) { this.grupoIsFinal = grupoIsFinal; }

    @Override
    public String toString() {
        return "TablaII_Is{" +
                "tabla2isId=" + tabla2isId +
                ", grupoIsInicial='" + grupoIsInicial + '\'' +
                ", intervaloMinMin=" + intervaloMinMin +
                ", intervaloMaxMin=" + intervaloMaxMin +
                ", grupoIsFinal='" + grupoIsFinal + '\'' +
                '}';
    }
}
