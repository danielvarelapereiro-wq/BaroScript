package com.BaroScript.repository;

import com.BaroScript.model.HojaInmersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface HojaInmersionDAO extends JpaRepository<HojaInmersion, Integer> {

    // Todas las hojas de un usuario ordenadas
    List<HojaInmersion> findByUsuarioUsuarioIdOrderByFechaDescCreatedAtDesc(Integer usuarioId);

    // Contar hojas creadas, para aplicar límite de rol USER (1 inmer/dia)
    long countByUsuarioUsuarioIdAndFecha(Integer usuarioId, LocalDate fecha);

    // Hojas pendientes de sincronizar (syncedAt null)
    @Query("SELECT h FROM HojaInmersion h " +
            "WHERE h.usuario.usuarioId = :usuarioId " +
            "AND h.syncedAt IS NULL " +
            "ORDER BY h.createdAt ASC")
    List<HojaInmersion> findPendientesSincronizar(@Param("usuarioId") Integer usuarioId);



}
