package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "tabla_VII")
public class TablaVII {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tabla7_id")
    private Integer tabla7Id;

    @Column(name = "profundidad", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidad;

    @Column(name = "tiempo_limite_nodeco", nullable = false)
    private Integer tiempoLimiteNodeco;

    @Column(name = "grupo_A") private Integer grupoA;
    @Column(name = "grupo_B") private Integer grupoB;
    @Column(name = "grupo_C") private Integer grupoC;
    @Column(name = "grupo_D") private Integer grupoD;
    @Column(name = "grupo_E") private Integer grupoE;
    @Column(name = "grupo_F") private Integer grupoF;
    @Column(name = "grupo_G") private Integer grupoG;
    @Column(name = "grupo_H") private Integer grupoH;
    @Column(name = "grupo_I") private Integer grupoI;
    @Column(name = "grupo_J") private Integer grupoJ;
    @Column(name = "grupo_K") private Integer grupoK;
    @Column(name = "grupo_L") private Integer grupoL;
    @Column(name = "grupo_M") private Integer grupoM;
    @Column(name = "grupo_N") private Integer grupoN;
    @Column(name = "grupo_O") private Integer grupoO;
    @Column(name = "grupo_Z") private Integer grupoZ;

    public TablaVII() {}

    public Integer getTabla7Id() { return tabla7Id; }
    public void setTabla7Id(Integer tabla7Id) { this.tabla7Id = tabla7Id; }

    public BigDecimal getProfundidad() { return profundidad; }
    public void setProfundidad(BigDecimal profundidad) { this.profundidad = profundidad; }

    public Integer getTiempoLimiteNodeco() { return tiempoLimiteNodeco; }
    public void setTiempoLimiteNodeco(Integer tiempoLimiteNodeco) { this.tiempoLimiteNodeco = tiempoLimiteNodeco; }

    public Integer getGrupoA() { return grupoA; }
    public void setGrupoA(Integer grupoA) { this.grupoA = grupoA; }

    public Integer getGrupoB() { return grupoB; }
    public void setGrupoB(Integer grupoB) { this.grupoB = grupoB; }

    public Integer getGrupoC() { return grupoC; }
    public void setGrupoC(Integer grupoC) { this.grupoC = grupoC; }

    public Integer getGrupoD() { return grupoD; }
    public void setGrupoD(Integer grupoD) { this.grupoD = grupoD; }

    public Integer getGrupoE() { return grupoE; }
    public void setGrupoE(Integer grupoE) { this.grupoE = grupoE; }

    public Integer getGrupoF() { return grupoF; }
    public void setGrupoF(Integer grupoF) { this.grupoF = grupoF; }

    public Integer getGrupoG() { return grupoG; }
    public void setGrupoG(Integer grupoG) { this.grupoG = grupoG; }

    public Integer getGrupoH() { return grupoH; }
    public void setGrupoH(Integer grupoH) { this.grupoH = grupoH; }

    public Integer getGrupoI() { return grupoI; }
    public void setGrupoI(Integer grupoI) { this.grupoI = grupoI; }

    public Integer getGrupoJ() { return grupoJ; }
    public void setGrupoJ(Integer grupoJ) { this.grupoJ = grupoJ; }

    public Integer getGrupoK() { return grupoK; }
    public void setGrupoK(Integer grupoK) { this.grupoK = grupoK; }

    public Integer getGrupoL() { return grupoL; }
    public void setGrupoL(Integer grupoL) { this.grupoL = grupoL; }

    public Integer getGrupoM() { return grupoM; }
    public void setGrupoM(Integer grupoM) { this.grupoM = grupoM; }

    public Integer getGrupoN() { return grupoN; }
    public void setGrupoN(Integer grupoN) { this.grupoN = grupoN; }

    public Integer getGrupoO() { return grupoO; }
    public void setGrupoO(Integer grupoO) { this.grupoO = grupoO; }

    public Integer getGrupoZ() { return grupoZ; }
    public void setGrupoZ(Integer grupoZ) { this.grupoZ = grupoZ; }

    @Override
    public String toString() {
        return "TablaVII{" +
                "tabla7Id=" + tabla7Id +
                ", profundidad=" + profundidad +
                ", tiempoLimiteNodeco=" + tiempoLimiteNodeco +
                ", grupoA=" + grupoA +
                ", grupoB=" + grupoB +
                ", grupoC=" + grupoC +
                ", grupoD=" + grupoD +
                ", grupoE=" + grupoE +
                ", grupoF=" + grupoF +
                ", grupoG=" + grupoG +
                ", grupoH=" + grupoH +
                ", grupoI=" + grupoI +
                ", grupoJ=" + grupoJ +
                ", grupoK=" + grupoK +
                ", grupoL=" + grupoL +
                ", grupoM=" + grupoM +
                ", grupoN=" + grupoN +
                ", grupoO=" + grupoO +
                ", grupoZ=" + grupoZ +
                '}';
    }
}
