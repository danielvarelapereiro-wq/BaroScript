package com.BaroScript.dto.response;

import java.time.LocalDateTime;

// lo que devuelve la API cuando se consulta un buceador
public class BuceadorResponseDTO {

    private Integer buceadorId;
    private String nombre;
    private String apellidos;
    private String titulacion;
    private LocalDateTime createdAt;

    public BuceadorResponseDTO() {}

    public BuceadorResponseDTO(Integer buceadorId, String nombre, String apellidos,
                               String titulacion, LocalDateTime createdAt) {
        this.buceadorId = buceadorId;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.titulacion = titulacion;
        this.createdAt = createdAt;
    }

    public Integer getBuceadorId() { return buceadorId; }
    public void setBuceadorId(Integer buceadorId) { this.buceadorId = buceadorId; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getTitulacion() { return titulacion; }
    public void setTitulacion(String titulacion) { this.titulacion = titulacion; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

}
