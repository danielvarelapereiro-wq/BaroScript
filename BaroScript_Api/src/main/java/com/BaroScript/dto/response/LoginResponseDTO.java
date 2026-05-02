package com.BaroScript.dto.response;

public class LoginResponseDTO {

    private String token;
    private String userName;
    private String rol;

    public LoginResponseDTO() {}

    public LoginResponseDTO(String token, String userName, String rol) {
        this.token = token;
        this.userName = userName;
        this.rol = rol;
    }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
}
