package com.BaroScript.service.impl;

import com.BaroScript.dto.request.HojaInmersionRequestDTO;
import com.BaroScript.dto.response.BuceadorResponseDTO;
import com.BaroScript.dto.response.HojaInmersionResponseDTO;
import com.BaroScript.model.Buceador;
import com.BaroScript.model.HojaInmersion;
import com.BaroScript.model.InmersionBuceador;
import com.BaroScript.model.Usuario;
import com.BaroScript.repository.BuceadorDAO;
import com.BaroScript.repository.HojaInmersionDAO;
import com.BaroScript.repository.InmersionBuceadorDAO;
import com.BaroScript.repository.UsuarioDAO;
import com.BaroScript.service.HojaInmersionService;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class HojaInmersionServiceImpl implements HojaInmersionService {

    private final HojaInmersionDAO hojaInmersionDAO;
    private final UsuarioDAO usuarioDAO;
    private final BuceadorDAO buceadorDAO;
    private final InmersionBuceadorDAO inmersionBuceadorDAO;

    public HojaInmersionServiceImpl(HojaInmersionDAO hojaInmersionDAO,
                                    UsuarioDAO usuarioDAO,
                                    BuceadorDAO buceadorDAO,
                                    InmersionBuceadorDAO inmersionBuceadorDAO) {
        this.hojaInmersionDAO = hojaInmersionDAO;
        this.usuarioDAO = usuarioDAO;
        this.buceadorDAO = buceadorDAO;
        this.inmersionBuceadorDAO = inmersionBuceadorDAO;
    }

    @Override
    public List<HojaInmersionResponseDTO> findByUsuario(Integer usuarioId) {
        List<HojaInmersion> hojas =
                hojaInmersionDAO.findByUsuarioUsuarioIdOrderByFechaDescCreatedAtDesc(usuarioId);
        List<HojaInmersionResponseDTO> resultado = new ArrayList<>();
        for (HojaInmersion h : hojas) {
            resultado.add(toDto(h));
        }
        return resultado;
    }

    @Override
    public HojaInmersionResponseDTO findById(Integer hojaId, Integer usuarioId) {
        HojaInmersion hoja = getHojaDelUsuario(hojaId, usuarioId);
        return toDto(hoja);
    }

    @Override
    public HojaInmersionResponseDTO crear(HojaInmersionRequestDTO dto, Integer usuarioId) {
        Usuario usuario = usuarioDAO.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Usuario no encontrado"));

        // Límite diario para rol USER: máximo 1 hoja por día
        String nombreRol = usuario.getRol().getNombre();
        if ("USER".equals(nombreRol)) {
            long hojasHoy = hojaInmersionDAO.countByUsuarioUsuarioIdAndFecha(
                    usuarioId, LocalDate.now());
            if (hojasHoy >= 1) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                        "Has alcanzado el límite diario de 1 inmersión. " +
                                "Actualiza a cuenta Premium para registrar más.");
            }
        }

        HojaInmersion hoja = new HojaInmersion();
        hoja.setUsuario(usuario);
        rellenarCampos(hoja, dto);

        // Las hojas creadas desde la API se marcan directamente como sincronizadas
        hoja.setSyncedAt(LocalDateTime.now());

        HojaInmersion guardada = hojaInmersionDAO.save(hoja);
        asociarBuceadores(guardada, dto);

        return toDto(guardada);
    }

    @Override
    public HojaInmersionResponseDTO actualizar(Integer hojaId, HojaInmersionRequestDTO dto,
                                               Integer usuarioId) {
        HojaInmersion hoja = getHojaDelUsuario(hojaId, usuarioId);
        rellenarCampos(hoja, dto);
        HojaInmersion actualizada = hojaInmersionDAO.save(hoja);
        return toDto(actualizada);
    }

    @Override
    public void eliminar(Integer hojaId, Integer usuarioId) {
        HojaInmersion hoja = getHojaDelUsuario(hojaId, usuarioId);
        hojaInmersionDAO.delete(hoja);
    }

    @Override
    public List<HojaInmersionResponseDTO> sincronizar(List<HojaInmersionRequestDTO> hojas,
                                                      Integer usuarioId) {
        /* La app manda las hojas creadas offline (syncedAt == null en Room)
        se guardan en la API y se devuelven marcadas con syncedAt */
        List<HojaInmersionResponseDTO> resultado = new ArrayList<>();
        for (HojaInmersionRequestDTO dto : hojas) {
            HojaInmersionResponseDTO guardada = crear(dto, usuarioId);
            resultado.add(guardada);
        }
        return resultado;
    }

    private void rellenarCampos(HojaInmersion hoja, HojaInmersionRequestDTO dto) {
        hoja.setFecha(dto.getFecha());
        hoja.setLugar(dto.getLugar());
        hoja.setEmpresa(dto.getEmpresa());
        hoja.setFinalidad(dto.getFinalidad());
        hoja.setProfundidadMax(dto.getProfundidadMax());
        hoja.setTiempoFondo(dto.getTiempoFondo());
        hoja.setMezclaDescompresion(dto.getMezclaDescompresion());
        hoja.setAlturaInmersion(dto.getAlturaInmersion());
        /* paradas y grupo vienen calculadas desde Room en la app
         y se guardan tal cual en la API para poder consultarlas desde otro dispositivo */
    }

    // Asocia los buceadores a la hoja en la tabla intermedia
    private void asociarBuceadores(HojaInmersion hoja, HojaInmersionRequestDTO dto) {
        if (dto.getBuceadorIds() == null || dto.getBuceadorIds().isEmpty()) return;

        for (Integer buceadorId : dto.getBuceadorIds()) {
            Buceador buceador = buceadorDAO.findById(buceadorId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                            "Buceador no encontrado con id: " + buceadorId));

            boolean esJefe = dto.getJefeEquipoId() != null &&
                    dto.getJefeEquipoId().equals(buceadorId);

            InmersionBuceador ib = new InmersionBuceador(hoja, buceador, esJefe);
            inmersionBuceadorDAO.save(ib);
        }
    }

    // Verifica que la hoja existe y pertenece al usuario
    private HojaInmersion getHojaDelUsuario(Integer hojaId, Integer usuarioId) {
        HojaInmersion hoja = hojaInmersionDAO.findById(hojaId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Hoja de inmersión no encontrada con id: " + hojaId));

        if (!hoja.getUsuario().getUsuarioId().equals(usuarioId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "No tienes permiso para acceder a esta hoja de inmersión");
        }
        return hoja;
    }

    // Mapper entidad DTO
    private HojaInmersionResponseDTO toDto(HojaInmersion h) {
        HojaInmersionResponseDTO dto = new HojaInmersionResponseDTO();
        dto.setHojaId(h.getHojaId());
        dto.setFecha(h.getFecha());
        dto.setLugar(h.getLugar());
        dto.setEmpresa(h.getEmpresa());
        dto.setFinalidad(h.getFinalidad());
        dto.setProfundidadMax(h.getProfundidadMax());
        dto.setTiempoFondo(h.getTiempoFondo());
        dto.setMezclaDescompresion(h.getMezclaDescompresion());
        dto.setAlturaInmersion(h.getAlturaInmersion());
        dto.settPrimeraParada(h.gettPrimeraParada());
        dto.setProfundidadTeorica(h.getProfundidadTeorica());
        dto.setParada39(h.getParada39());
        dto.setParada36(h.getParada36());
        dto.setParada33(h.getParada33());
        dto.setParada30(h.getParada30());
        dto.setParada27(h.getParada27());
        dto.setParada24(h.getParada24());
        dto.setParada21(h.getParada21());
        dto.setParada18(h.getParada18());
        dto.setParada15(h.getParada15());
        dto.setParada12(h.getParada12());
        dto.setParada9(h.getParada9());
        dto.setParada6(h.getParada6());
        dto.setTiempoTotalAscenso(h.getTiempoTotalAscenso());
        dto.setPeriodosO2Camara(h.getPeriodosO2Camara());
        dto.setGrupoInmersion(h.getGrupoInmersion());
        dto.setEsInmersionSucesiva(h.getEsInmersionSucesiva());
        dto.setCreatedAt(h.getCreatedAt());
        dto.setSyncedAt(h.getSyncedAt());

        // Mapear los buceadores de la relación N:M
        List<BuceadorResponseDTO> buceadoresDto = new ArrayList<>();
        if (h.getBuceadores() != null) {
            for (InmersionBuceador ib : h.getBuceadores()) {
                Buceador b = ib.getBuceador();
                buceadoresDto.add(new BuceadorResponseDTO(
                        b.getBuceadorId(),
                        b.getNombre(),
                        b.getApellidos(),
                        b.getTitulacion(),
                        b.getCreatedAt()
                ));
            }
        }
        dto.setBuceadores(buceadoresDto);

        return dto;
    }

}
