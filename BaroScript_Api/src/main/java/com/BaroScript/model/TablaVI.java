package com.BaroScript.model;

import jakarta.persistence.*;

@Entity
@Table(name = "tabla_VI")
public class TablaVI {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla6_id")
    private Integer tabla6Id;

    @Column(name = "grupo_is", nullable = false, length = 1)
    private String grupoIs;

    @Column(name = "aumento_altitud_m", nullable = false)
    private Integer aumentoAltitudM;

    // String tipo h:m, ej: "5:24", "0:00"
    @Column(name = "intervalo_requerido", nullable = false, length = 10)
    private String intervaloRequerido;

    public TablaVI() {}

    public Integer getTabla6Id() { return tabla6Id; }
    public void setTabla6Id(Integer tabla6Id) { this.tabla6Id = tabla6Id; }

    public String getGrupoIs() { return grupoIs; }
    public void setGrupoIs(String grupoIs) { this.grupoIs = grupoIs; }

    public Integer getAumentoAltitudM() { return aumentoAltitudM; }
    public void setAumentoAltitudM(Integer aumentoAltitudM) { this.aumentoAltitudM = aumentoAltitudM; }

    public String getIntervaloRequerido() { return intervaloRequerido; }
    public void setIntervaloRequerido(String intervaloRequerido) { this.intervaloRequerido = intervaloRequerido; }

    @Override
    public String toString() {
        return "TablaVI{" +
                "tabla6Id=" + tabla6Id +
                ", grupoIs='" + grupoIs + '\'' +
                ", aumentoAltitudM=" + aumentoAltitudM +
                ", intervaloRequerido='" + intervaloRequerido + '\'' +
                '}';
    }
}
