package com.BaroScript.service;

import com.BaroScript.dto.request.HojaInmersionRequestDTO;
import com.BaroScript.dto.response.HojaInmersionResponseDTO;

import java.util.List;

public interface HojaInmersionService {

    List<HojaInmersionResponseDTO> findByUsuario(Integer usuarioId);

    HojaInmersionResponseDTO findById(Integer hojaId, Integer usuarioId);

    // crea hoja y la marca como sincronizada (syncedAt = now)
    // aplica el límite diario
    HojaInmersionResponseDTO crear(HojaInmersionRequestDTO dto, Integer usuarioId);

    HojaInmersionResponseDTO actualizar(Integer hojaId, HojaInmersionRequestDTO dto, Integer usuarioId);

    void eliminar(Integer hojaId, Integer usuarioId);

    // La app manda las hojas pendientes (syncedAt == null en Room)
    // El servicio las guarda y las marca con syncedAt
    List<HojaInmersionResponseDTO> sincronizar(List<HojaInmersionRequestDTO> hojas, Integer usuarioId);
}
