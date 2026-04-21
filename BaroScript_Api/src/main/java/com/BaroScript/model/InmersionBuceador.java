package com.BaroScript.model;

import jakarta.persistence.*;

@Entity
@Table(name = "inmersion_buceadores")
public class InmersionBuceador {

    // clave primaria compuesta (hoja_id + buceador_id)
    @EmbeddedId
    private PkInmersionBuceador id;

    @ManyToOne
    @MapsId("hojaId")
    @JoinColumn(name = "hoja_id", nullable = false)
    private HojaInmersion hojaInmersion;

    @ManyToOne
    @MapsId("buceadorId")
    @JoinColumn(name = "buceador_id", nullable = false)
    private Buceador buceador;

    @Column(name = "es_jefe_equipo")
    private Boolean esJefeEquipo;


    public InmersionBuceador() {
        this.id = new PkInmersionBuceador();
        this.esJefeEquipo = false;
    }

    public InmersionBuceador(HojaInmersion hojaInmersion, Buceador buceador, Boolean esJefeEquipo) {
        this.id = new PkInmersionBuceador(hojaInmersion.getHojaId(), buceador.getBuceadorId());
        this.hojaInmersion = hojaInmersion;
        this.buceador = buceador;
        this.esJefeEquipo = esJefeEquipo;
    }

    public PkInmersionBuceador getId() { return id; }
    public void setId(PkInmersionBuceador id) { this.id = id; }

    public HojaInmersion getHojaInmersion() { return hojaInmersion; }
    public void setHojaInmersion(HojaInmersion hojaInmersion) { this.hojaInmersion = hojaInmersion; }

    public Buceador getBuceador() { return buceador; }
    public void setBuceador(Buceador buceador) { this.buceador = buceador; }

    public Boolean getEsJefeEquipo() { return esJefeEquipo; }
    public void setEsJefeEquipo(Boolean esJefeEquipo) { this.esJefeEquipo = esJefeEquipo; }

    @Override
    public String toString() {
        return "InmersionBuceador{" +
                "id=" + id +
                ", hojaInmersion=" + hojaInmersion +
                ", buceador=" + buceador +
                ", esJefeEquipo=" + esJefeEquipo +
                '}';
    }
}
