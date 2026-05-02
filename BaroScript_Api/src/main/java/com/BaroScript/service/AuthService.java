package com.BaroScript.service;

import com.BaroScript.dto.request.LoginRequestDTO;
import com.BaroScript.dto.request.RegisterRequestDTO;
import com.BaroScript.dto.response.LoginResponseDTO;

public interface AuthService {

    // Registra un nuevo usuario con rol USER por defecto
    // excepción si userName o email ya existen
    void register(RegisterRequestDTO dto);

    // Autentica al usuario y devuelve el JWT
    // excepción con credenciales son incorrectas
    LoginResponseDTO login(LoginRequestDTO dto);
}
