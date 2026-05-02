package com.BaroScript.security;

import com.BaroScript.model.Usuario;
import com.BaroScript.repository.UsuarioDAO;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.List;

public class UserDetailsServiceImpl implements UserDetailsService {

    private final UsuarioDAO usuarioRepository;

    public UserDetailsServiceImpl(UsuarioDAO usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByUserName(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));

        // Devolvemos el UserDetails con la contraseña cifrada (BCrypt) tal como está en BBDD
        // Spring Security comparará internamente con BCryptPasswordEncoder
        return User.withUsername(usuario.getUserName())
                .password(usuario.getPasswordHash())
                .authorities(List.of(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().getNombre())))
                .build();
    }
}
