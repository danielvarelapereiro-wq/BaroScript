package com.BaroScript.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "hojas_inmersion")
public class HojaInmersion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "hoja_id")
    private Integer hojaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "lugar", length = 200)
    private String lugar;

    @Column(name = "empresa", length = 100)
    private String empresa;

    @Column(name = "finalidad", columnDefinition = "TEXT")
    private String finalidad;

    @Column(name = "profundidad_max", nullable = false, precision = 3, scale = 1)
    private BigDecimal profundidadMax;

    @Column(name = "tiempo_fondo", nullable = false)
    private Integer tiempoFondo;

    @Column(name = "mezcla_descompresion", nullable = false, length = 20)
    private String mezclaDescompresion;

    @Column(name = "altura_inmersion", precision = 7, scale = 1)
    private BigDecimal alturaInmersion;

    @Column(name = "t_primera_parada", length = 10)
    private String tPrimeraParada;

    @Column(name = "profundidad_teorica", precision = 5, scale = 1)
    private BigDecimal profundidadTeorica;

    // Paradas excepcionales (para inmers hasta 90 mca)
    @Column(name = "parada_39") private Integer parada39;
    @Column(name = "parada_36") private Integer parada36;
    @Column(name = "parada_33") private Integer parada33;
    // Paradas basicas
    @Column(name = "parada_30") private Integer parada30;
    @Column(name = "parada_27") private Integer parada27;
    @Column(name = "parada_24") private Integer parada24;
    @Column(name = "parada_21") private Integer parada21;
    @Column(name = "parada_18") private Integer parada18;
    @Column(name = "parada_15") private Integer parada15;
    @Column(name = "parada_12") private Integer parada12;
    @Column(name = "parada_9")  private Integer parada9;
    @Column(name = "parada_6")  private Integer parada6;

    @Column(name = "tiempo_total_ascenso", length = 10)
    private String tiempoTotalAscenso;

    @Column(name = "periodos_o2_camara", precision = 4, scale = 1)
    private BigDecimal periodosO2Camara;

    @Column(name = "grupo_inmersion", length = 1)
    private String grupoInmersion;

    @Column(name = "es_inmersion_sucesiva")
    private Boolean esInmersionSucesiva;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "synced_at")
    private LocalDateTime syncedAt;

    @OneToMany(mappedBy = "hojaInmersion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<InmersionBuceador> buceadores;

    public HojaInmersion() {
        this.createdAt = LocalDateTime.now();
        this.esInmersionSucesiva = false;
        this.buceadores = new ArrayList<>();
    }


    public Integer getHojaId() { return hojaId; }
    public void setHojaId(Integer hojaId) { this.hojaId = hojaId; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

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

    public List<InmersionBuceador> getBuceadores() { return buceadores; }
    public void setBuceadores(List<InmersionBuceador> buceadores) { this.buceadores = buceadores; }

    @Override
    public String toString() {
        return "HojaInmersion{" +
                "hojaId=" + hojaId +
                ", usuario=" + usuario +
                ", fecha=" + fecha +
                ", lugar='" + lugar + '\'' +
                ", empresa='" + empresa + '\'' +
                ", finalidad='" + finalidad + '\'' +
                ", profundidadMax=" + profundidadMax +
                ", tiempoFondo=" + tiempoFondo +
                ", mezclaDescompresion='" + mezclaDescompresion + '\'' +
                ", alturaInmersion=" + alturaInmersion +
                ", tPrimeraParada='" + tPrimeraParada + '\'' +
                ", profundidadTeorica=" + profundidadTeorica +
                ", parada39=" + parada39 +
                ", parada36=" + parada36 +
                ", parada33=" + parada33 +
                ", parada30=" + parada30 +
                ", parada27=" + parada27 +
                ", parada24=" + parada24 +
                ", parada21=" + parada21 +
                ", parada18=" + parada18 +
                ", parada15=" + parada15 +
                ", parada12=" + parada12 +
                ", parada9=" + parada9 +
                ", parada6=" + parada6 +
                ", tiempoTotalAscenso='" + tiempoTotalAscenso + '\'' +
                ", periodosO2Camara=" + periodosO2Camara +
                ", grupoInmersion='" + grupoInmersion + '\'' +
                ", esInmersionSucesiva=" + esInmersionSucesiva +
                ", createdAt=" + createdAt +
                ", syncedAt=" + syncedAt +
                ", buceadores=" + buceadores +
                '}';
    }
}
