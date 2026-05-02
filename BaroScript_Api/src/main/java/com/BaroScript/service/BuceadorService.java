package com.BaroScript.service;

import com.BaroScript.dto.request.BuceadorRequestDTO;
import com.BaroScript.dto.response.BuceadorResponseDTO;

import java.util.List;

public interface BuceadorService {

    List<BuceadorResponseDTO> findByUsuario(Integer usuarioId);

    BuceadorResponseDTO findById(Integer buceadorId, Integer usuarioId);

    BuceadorResponseDTO crear(BuceadorRequestDTO dto, Integer usuarioId);

    BuceadorResponseDTO actualizar(Integer buceadorId, BuceadorRequestDTO dto, Integer usuarioId);

    void eliminar(Integer buceadorId, Integer usuarioId);

}
