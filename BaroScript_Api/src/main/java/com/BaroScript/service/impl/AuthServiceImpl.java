package com.BaroScript.service.impl;

import com.BaroScript.dto.request.LoginRequestDTO;
import com.BaroScript.dto.request.RegisterRequestDTO;
import com.BaroScript.dto.response.LoginResponseDTO;
import com.BaroScript.model.Rol;
import com.BaroScript.model.Usuario;
import com.BaroScript.repository.RolDAO;
import com.BaroScript.repository.UsuarioDAO;
import com.BaroScript.security.JwtUtil;
import com.BaroScript.service.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

public class AuthServiceImpl implements AuthService {

    private final UsuarioDAO usuarioDAO;
    private final RolDAO rolDAO;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthServiceImpl(UsuarioDAO usuarioDAO, RolDAO rolDAO,
                           PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.usuarioDAO = usuarioDAO;
        this.rolDAO = rolDAO;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    @Override
    public void register(RegisterRequestDTO dto) {

        // Comprobar duplicados antes de crear nada
        if (usuarioDAO.existsByUserName(dto.getUserName())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "El nombre de usuario '" + dto.getUserName() + "' ya está en uso");
        }
        if (usuarioDAO.existsByEmail(dto.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "El email '" + dto.getEmail() + "' ya está registrado");
        }

        // Rol por defecto siempre USER
        Rol rol = rolDAO.findByNombre("USER")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                        "Rol USER no encontrado en la base de datos"));

        // Hashear la contraseña con BCrypt
        String passwordHash = passwordEncoder.encode(dto.getPassword());

        Usuario usuario = new Usuario();
        usuario.setUserName(dto.getUserName());
        usuario.setEmail(dto.getEmail());
        usuario.setPasswordHash(passwordHash);
        usuario.setRol(rol);

        usuarioDAO.save(usuario);
    }

    @Override
    public LoginResponseDTO login(LoginRequestDTO dto) {

        Usuario usuario = usuarioDAO.findByUserName(dto.getUserName())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                        "Credenciales incorrectas"));

        // Comprobar contraseña con BCrypt, matches compara sin descifrar
        if (!passwordEncoder.matches(dto.getPassword(), usuario.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                    "Credenciales incorrectas");
        }

        if (!usuario.getActivo()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Usuario desactivado. Contacte con el administrador");
        }

        // Generar JWT con userName y nombre del rol
        String token = jwtUtil.generateToken(
                usuario.getUserName(),
                usuario.getRol().getNombre()
        );

        return new LoginResponseDTO(token, usuario.getUserName(), usuario.getRol().getNombre());
    }
}
