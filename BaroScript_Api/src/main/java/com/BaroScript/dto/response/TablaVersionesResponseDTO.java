package com.BaroScript.dto.response;

import java.time.LocalDateTime;

public class TablaVersionesResponseDTO {

    private Integer versionId;
    private LocalDateTime ultimaModificacion;
    private String versionTag;
    private String descripcion;

    public TablaVersionesResponseDTO() {}

    public TablaVersionesResponseDTO(Integer versionId, LocalDateTime ultimaModificacion,
                                     String versionTag, String descripcion) {
        this.versionId = versionId;
        this.ultimaModificacion = ultimaModificacion;
        this.versionTag = versionTag;
        this.descripcion = descripcion;
    }

    public Integer getVersionId() { return versionId; }
    public void setVersionId(Integer versionId) { this.versionId = versionId; }

    public LocalDateTime getUltimaModificacion() { return ultimaModificacion; }
    public void setUltimaModificacion(LocalDateTime ultimaModificacion) { this.ultimaModificacion = ultimaModificacion; }

    public String getVersionTag() { return versionTag; }
    public void setVersionTag(String versionTag) { this.versionTag = versionTag; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
}
