package co.edu.poli.ces3.gestoreventosdeportivos.dao;

import java.util.ArrayList;
import java.util.Stack;

public class EquipoDAO {
    private int id;
    private String nombre;
    private String deporte;
    private String ciudad;
    private String fechaFundacion;
    private String logo;
    private Stack<Integer> jugadores;

    public EquipoDAO() {}

    public EquipoDAO(String nombre, String deporte, String ciudad, String fechaFundacion, String logo, Stack<Integer> jugadores) {
        this.nombre = nombre;
        this.deporte = deporte;
        this.ciudad = ciudad;
        this.fechaFundacion = fechaFundacion;
        this.logo = logo;
        this.jugadores = jugadores;
    }

    public EquipoDAO(int id, String nombre, String deporte, String ciudad, String fechaFundacion, String logo, Stack<Integer> ids_jugadores) {
        this.id = id;
        this.nombre = nombre;
        this.deporte = deporte;
        this.ciudad = ciudad;
        this.fechaFundacion = fechaFundacion;
        this.logo = logo;
        this.jugadores  = jugadores;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDeporte() {
        return deporte;
    }

    public void setDeporte(String deporte) {
        this.deporte = deporte;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getFechaFundacion() {
        return fechaFundacion;
    }

    public void setFechaFundacion(String fechaFundacion) {
        this.fechaFundacion = fechaFundacion;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public Stack<Integer> getJugadores () {
        return jugadores;
    }

    public void setJugadores(Stack<Integer> jugadores) {
        this.jugadores = jugadores;
    }

    public void agregarJugador(int idJugador) {
        this.jugadores.push(idJugador);
    }

    public void removerJugador(int idJugador) {
        this.jugadores.remove((Integer) idJugador);
    }

    public int removerUltimoJugador() {
        if (!this.jugadores.isEmpty()) {
            return this.jugadores.pop();
        }
        return -1; //si la pila esta vacia
    }
}
