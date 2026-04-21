package com.BaroScript.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "tabla_versiones")
public class TablaVersiones {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "version_id")
    private Integer versionId;

    @Column(name = "ultima_modificacion", nullable = false)
    private LocalDateTime ultimaModificacion;

    @Column(name = "version_tag", nullable = false, length = 20)
    private String versionTag;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    public TablaVersiones() {}

    public Integer getVersionId() { return versionId; }
    public void setVersionId(Integer versionId) { this.versionId = versionId; }

    public LocalDateTime getUltimaModificacion() { return ultimaModificacion; }
    public void setUltimaModificacion(LocalDateTime ultimaModificacion) { this.ultimaModificacion = ultimaModificacion; }

    public String getVersionTag() { return versionTag; }
    public void setVersionTag(String versionTag) { this.versionTag = versionTag; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    @Override
    public String toString() {
        return "TablaVersiones{" +
                "versionId=" + versionId +
                ", ultimaModificacion=" + ultimaModificacion +
                ", versionTag='" + versionTag + '\'' +
                ", descripcion='" + descripcion + '\'' +
                '}';
    }
}
