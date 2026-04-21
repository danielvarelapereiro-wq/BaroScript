package com.BaroScript.model;

import jakarta.persistence.*;

@Entity
@Table(name = "tabla_V")
public class TablaV {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla5_id")
    private Integer tabla5Id;

    @Column(name = "altitud_m", nullable = false)
    private Integer altitudM;

    @Column(name = "altitud_pies")
    private Integer altitudPies;

    @Column(name = "grupo_is", nullable = false, length = 1)
    private String grupoIs;

    public TablaV() {}

    public Integer getTabla5Id() { return tabla5Id; }
    public void setTabla5Id(Integer tabla5Id) { this.tabla5Id = tabla5Id; }

    public Integer getAltitudM() { return altitudM; }
    public void setAltitudM(Integer altitudM) { this.altitudM = altitudM; }

    public Integer getAltitudPies() { return altitudPies; }
    public void setAltitudPies(Integer altitudPies) { this.altitudPies = altitudPies; }

    public String getGrupoIs() { return grupoIs; }
    public void setGrupoIs(String grupoIs) { this.grupoIs = grupoIs; }

    @Override
    public String toString() {
        return "TablaV{" +
                "tabla5Id=" + tabla5Id +
                ", altitudM=" + altitudM +
                ", altitudPies=" + altitudPies +
                ", grupoIs='" + grupoIs + '\'' +
                '}';
    }
}
