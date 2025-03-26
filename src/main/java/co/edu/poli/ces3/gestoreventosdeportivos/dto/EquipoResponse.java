package co.edu.poli.ces3.gestoreventosdeportivos.dto;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;

import java.util.List;

    public class EquipoResponse {
    private int id;
    private String nombre;
    private String deporte;
    private String ciudad;
    private String fechaFundacion;
    private String logo;
    private List<JugadorBasico> jugadores;

    public EquipoResponse(EquipoDAO equipo, List<JugadorBasico> jugadores) {
        this.id = equipo.getId();
        this.nombre = equipo.getNombre();
        this.deporte = equipo.getDeporte();
        this.ciudad = equipo.getCiudad();
        this.fechaFundacion = equipo.getFechaFundacion();
        this.logo = equipo.getLogo();
        this.jugadores = jugadores;
    }

    public int getId() {
        return id;
    }


    public String getNombre() {
        return nombre;
    }


    public String getDeporte() {
        return deporte;
    }


    public String getCiudad() {
        return ciudad;
    }


    public String getFechaFundacion() {
        return fechaFundacion;
    }


    public String getLogo() {
        return logo;
    }


    public List<JugadorBasico> getJugadores() {
        return jugadores;
    }

}
