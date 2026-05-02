package com.BaroScript.service.impl;

import com.BaroScript.dto.request.BuceadorRequestDTO;
import com.BaroScript.dto.response.BuceadorResponseDTO;
import com.BaroScript.model.Buceador;
import com.BaroScript.model.Usuario;
import com.BaroScript.repository.BuceadorDAO;
import com.BaroScript.repository.UsuarioDAO;
import com.BaroScript.service.BuceadorService;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
import java.util.ArrayList;
import java.util.List;

public class BuceadorServiceImpl implements BuceadorService {

    private final BuceadorDAO buceadorDAO;
    private final UsuarioDAO usuarioDAO;

    public BuceadorServiceImpl(BuceadorDAO buceadorDAO, UsuarioDAO usuarioDAO) {
        this.buceadorDAO = buceadorDAO;
        this.usuarioDAO = usuarioDAO;
    }

    @Override
    public List<BuceadorResponseDTO> findByUsuario(Integer usuarioId) {
        List<Buceador> buceadores = buceadorDAO.findByUsuarioUsuarioId(usuarioId);
        List<BuceadorResponseDTO> resultado = new ArrayList<>();
        for (Buceador b : buceadores) {
            resultado.add(toDto(b));
        }
        return resultado;
    }

    @Override
    public BuceadorResponseDTO findById(Integer buceadorId, Integer usuarioId) {
        Buceador buceador = getBuceadorDelUsuario(buceadorId, usuarioId);
        return toDto(buceador);
    }

    @Override
    public BuceadorResponseDTO crear(BuceadorRequestDTO dto, Integer usuarioId) {
        Usuario usuario = usuarioDAO.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Usuario no encontrado"));

        Buceador buceador = new Buceador();
        buceador.setUsuario(usuario);
        buceador.setNombre(dto.getNombre());
        buceador.setApellidos(dto.getApellidos());
        buceador.setTitulacion(dto.getTitulacion());

        Buceador guardado = buceadorDAO.save(buceador);
        return toDto(guardado);
    }

    @Override
    public BuceadorResponseDTO actualizar(Integer buceadorId, BuceadorRequestDTO dto,
                                          Integer usuarioId) {
        Buceador buceador = getBuceadorDelUsuario(buceadorId, usuarioId);

        buceador.setNombre(dto.getNombre());
        buceador.setApellidos(dto.getApellidos());
        buceador.setTitulacion(dto.getTitulacion());

        Buceador actualizado = buceadorDAO.save(buceador);
        return toDto(actualizado);
    }

    @Override
    public void eliminar(Integer buceadorId, Integer usuarioId) {
        Buceador buceador = getBuceadorDelUsuario(buceadorId, usuarioId);
        buceadorDAO.delete(buceador);
    }

    // Verifica que el buceador existe y pertenece al usuario autenticado
    // Evita que un usuario acceda a datos de otro
    private Buceador getBuceadorDelUsuario(Integer buceadorId, Integer usuarioId) {
        Buceador buceador = buceadorDAO.findById(buceadorId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Buceador no encontrado con id: " + buceadorId));

        if (!buceador.getUsuario().getUsuarioId().equals(usuarioId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "No tienes permiso para acceder a este buceador");
        }
        return buceador;
    }

    // Mapper entidad -> DTO
    private BuceadorResponseDTO toDto(Buceador b) {
        return new BuceadorResponseDTO(
                b.getBuceadorId(),
                b.getNombre(),
                b.getApellidos(),
                b.getTitulacion(),
                b.getCreatedAt()
        );
    }
}
