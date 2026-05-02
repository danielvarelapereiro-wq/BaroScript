package com.BaroScript.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

//Clave primaria compuesta para la tabla InmersionBuceador que es tabla intermedia N:M
@Embeddable
public class PkInmersionBuceador implements Serializable {

    @Column(name = "hoja_id")
    private Integer hojaId;

    @Column(name = "buceador_id")
    private Integer buceadorId;

    public PkInmersionBuceador() {}

    public PkInmersionBuceador(Integer hojaId, Integer buceadorId) {
        this.hojaId = hojaId;
        this.buceadorId = buceadorId;
    }

    public Integer getHojaId() { return hojaId; }
    public void setHojaId(Integer hojaId) { this.hojaId = hojaId; }

    public Integer getBuceadorId() { return buceadorId; }
    public void setBuceadorId(Integer buceadorId) { this.buceadorId = buceadorId; }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        PkInmersionBuceador that = (PkInmersionBuceador) o;
        return Objects.equals(hojaId, that.hojaId) && Objects.equals(buceadorId, that.buceadorId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(hojaId, buceadorId);
    }

    @Override
    public String toString() {
        return "PkInmersionBuceador{" +
                "hojaId=" + hojaId +
                ", buceadorId=" + buceadorId +
                '}';
    }


}
