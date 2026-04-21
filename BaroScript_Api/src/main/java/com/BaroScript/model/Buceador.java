package com.BaroScript.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "buceadores")
public class Buceador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "buceador_id")
    private Integer buceadorId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;

    @Column(name = "apellidos", nullable = false, length = 100)
    private String apellidos;

    @Column(name = "titulacion", length = 100)
    private String titulacion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "buceador", cascade = CascadeType.ALL)
    private List<InmersionBuceador> inmersiones;

    public Buceador() {
        this.createdAt = LocalDateTime.now();
        this.inmersiones = new ArrayList<>();
    }

    public Integer getBuceadorId() { return buceadorId; }
    public void setBuceadorId(Integer buceadorId) { this.buceadorId = buceadorId; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }

    public String getTitulacion() { return titulacion; }
    public void setTitulacion(String titulacion) { this.titulacion = titulacion; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<InmersionBuceador> getInmersiones() { return inmersiones; }
    public void setInmersiones(List<InmersionBuceador> inmersiones) { this.inmersiones = inmersiones; }

    @Override
    public String toString() {
        return "Buceador{" +
                "buceadorId=" + buceadorId +
                ", usuario=" + usuario +
                ", nombre='" + nombre + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", titulacion='" + titulacion + '\'' +
                ", createdAt=" + createdAt +
                ", inmersiones=" + inmersiones +
                '}';
    }
}
