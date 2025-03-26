package co.edu.poli.ces3.gestoreventosdeportivos.dao;

import java.util.Stack;

public class EventoDAO {
    private int id;
    private String nombre;
    private String fecha;
    private String lugar;
    private String deporte;
    private Stack<Integer> equiposParticipantes;
    private int capacidad;
    private int entradasVendidas;
    private String estado; // "Programado", "En curso", "Finalizado", "Cancelado"

    public EventoDAO() {
        this.equiposParticipantes = new Stack<>();
    }

    public EventoDAO(int id, String nombre, String fecha, String lugar, String deporte, Stack<Integer> equiposParticipantes, int capacidad, int entradasVendidas, String estado) {
        this.id = id;
        this.nombre = nombre;
        this.fecha = fecha;
        this.lugar = lugar;
        this.deporte = deporte;
        this.equiposParticipantes = equiposParticipantes;
        this.capacidad = capacidad;
        this.entradasVendidas = entradasVendidas;
        this.estado = estado;
    }

    public EventoDAO(String nombre, String fecha, String lugar, String deporte, Stack<Integer> equiposParticipantes, int capacidad, int entradasVendidas, String estado) {
        this.nombre = nombre;
        this.fecha = fecha;
        this.lugar = lugar;
        this.deporte = deporte;
        this.equiposParticipantes = equiposParticipantes;
        this.capacidad = capacidad;
        this.entradasVendidas = entradasVendidas;
        this.estado = estado;
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

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getLugar() {
        return lugar;
    }

    public void setLugar(String lugar) {
        this.lugar = lugar;
    }

    public String getDeporte() {
        return deporte;
    }

    public void setDeporte(String deporte) {
        this.deporte = deporte;
    }

    public Stack<Integer> getEquiposParticipantes() {
        return equiposParticipantes;
    }

    public void setEquiposParticipantes(Stack<Integer> equiposParticipantes) {
        this.equiposParticipantes = equiposParticipantes;
    }

    public void agregarEquiposParticipantes(int idEquipo) {
        if (!this.equiposParticipantes.contains(idEquipo)) {
            this.equiposParticipantes.push(idEquipo);
        }
    }

    public int getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(int capacidad) {
        this.capacidad = capacidad;
    }

    public int getEntradasVendidas() {
        return entradasVendidas;
    }

    public void setEntradasVendidas(int entradasVendidas) {
        this.entradasVendidas = entradasVendidas;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
