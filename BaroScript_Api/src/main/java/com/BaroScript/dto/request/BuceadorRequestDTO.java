package com.BaroScript.dto.request;

public class BuceadorRequestDTO {

    private String nombre;
    private String apellidos;
    private String titulacion;

    public BuceadorRequestDTO() {}

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getTitulacion() { return titulacion; }
    public void setTitulacion(String titulacion) { this.titulacion = titulacion; }
}
