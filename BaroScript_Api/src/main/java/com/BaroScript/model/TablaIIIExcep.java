package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_III_excep")
public class TablaIIIExcep {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla3_excep_id")
    private Integer tabla3ExcepId;

    @Column(name = "profundidad", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidad;

    @Column(name = "tiempo_fondo", nullable = false)
    private Integer tiempoFondo;

    @Column(name = "t_primera_parada", nullable = false, length = 10)
    private String tPrimeraParada;

    @Column(name = "mezcla", nullable = false, length = 10)
    private String mezcla;

    // Paradas excepcionales (para inmers hasta 90 mca)
    @Column(name = "d_39") private Integer d39;
    @Column(name = "d_36") private Integer d36;
    @Column(name = "d_33") private Integer d33;

    // Paradas basicas (hasta 30 mca)
    @Column(name = "d_30") private Integer d30;
    @Column(name = "d_27") private Integer d27;
    @Column(name = "d_24") private Integer d24;
    @Column(name = "d_21") private Integer d21;
    @Column(name = "d_18") private Integer d18;
    @Column(name = "d_15") private Integer d15;
    @Column(name = "d_12") private Integer d12;
    @Column(name = "d_9")  private Integer d9;
    @Column(name = "d_6")  private Integer d6;

    @Column(name = "tiempo_total_ascenso", nullable = false, length = 10)
    private String tiempoTotalAscenso;

    @Column(name = "periodos_o2_camara", precision = 4, scale = 1)
    private BigDecimal periodosO2Camara;

    @Column(name = "grupo_inmersion", length = 1)
    private String grupoInmersion;

    public TablaIIIExcep() {}

    public Integer getTabla3ExcepId() { return tabla3ExcepId; }
    public void setTabla3ExcepId(Integer tabla3ExcepId) { this.tabla3ExcepId = tabla3ExcepId; }

    public BigDecimal getProfundidad() { return profundidad; }
    public void setProfundidad(BigDecimal profundidad) { this.profundidad = profundidad; }

    public Integer getTiempoFondo() { return tiempoFondo; }
    public void setTiempoFondo(Integer tiempoFondo) { this.tiempoFondo = tiempoFondo; }

    public String gettPrimeraParada() { return tPrimeraParada; }
    public void settPrimeraParada(String tPrimeraParada) { this.tPrimeraParada = tPrimeraParada; }

    public String getMezcla() { return mezcla; }
    public void setMezcla(String mezcla) { this.mezcla = mezcla; }

    public Integer getD39() { return d39; }
    public void setD39(Integer d39) { this.d39 = d39; }

    public Integer getD36() { return d36; }
    public void setD36(Integer d36) { this.d36 = d36; }

    public Integer getD33() { return d33; }
    public void setD33(Integer d33) { this.d33 = d33; }

    public Integer getD30() { return d30; }
    public void setD30(Integer d30) { this.d30 = d30; }

    public Integer getD27() { return d27; }
    public void setD27(Integer d27) { this.d27 = d27; }

    public Integer getD24() { return d24; }
    public void setD24(Integer d24) { this.d24 = d24; }

    public Integer getD21() { return d21; }
    public void setD21(Integer d21) { this.d21 = d21; }

    public Integer getD18() { return d18; }
    public void setD18(Integer d18) { this.d18 = d18; }

    public Integer getD15() { return d15; }
    public void setD15(Integer d15) { this.d15 = d15; }

    public Integer getD12() { return d12; }
    public void setD12(Integer d12) { this.d12 = d12; }

    public Integer getD9() { return d9; }
    public void setD9(Integer d9) { this.d9 = d9; }

    public Integer getD6() { return d6; }
    public void setD6(Integer d6) { this.d6 = d6; }

    public String getTiempoTotalAscenso() { return tiempoTotalAscenso; }
    public void setTiempoTotalAscenso(String tiempoTotalAscenso) { this.tiempoTotalAscenso = tiempoTotalAscenso; }

    public BigDecimal getPeriodosO2Camara() { return periodosO2Camara; }
    public void setPeriodosO2Camara(BigDecimal periodosO2Camara) { this.periodosO2Camara = periodosO2Camara; }

    public String getGrupoInmersion() { return grupoInmersion; }
    public void setGrupoInmersion(String grupoInmersion) { this.grupoInmersion = grupoInmersion; }

    @Override
    public String toString() {
        return "TablaIIIExcep{" +
                "tabla3ExcepId=" + tabla3ExcepId +
                ", profundidad=" + profundidad +
                ", tiempoFondo=" + tiempoFondo +
                ", tPrimeraParada='" + tPrimeraParada + '\'' +
                ", mezcla='" + mezcla + '\'' +
                ", d39=" + d39 +
                ", d36=" + d36 +
                ", d33=" + d33 +
                ", d30=" + d30 +
                ", d27=" + d27 +
                ", d24=" + d24 +
                ", d21=" + d21 +
                ", d18=" + d18 +
                ", d15=" + d15 +
                ", d12=" + d12 +
                ", d9=" + d9 +
                ", d6=" + d6 +
                ", tiempoTotalAscenso='" + tiempoTotalAscenso + '\'' +
                ", periodosO2Camara=" + periodosO2Camara +
                ", grupoInmersion='" + grupoInmersion + '\'' +
                '}';
    }
}
