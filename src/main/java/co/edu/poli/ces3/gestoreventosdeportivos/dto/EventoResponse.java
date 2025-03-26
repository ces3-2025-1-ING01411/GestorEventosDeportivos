package co.edu.poli.ces3.gestoreventosdeportivos.dto;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;

import java.util.Map;
import java.util.Stack;

public class EventoResponse {
    private int id;
    private String nombre;
    private String fecha;
    private String lugar;
    private String deporte;
    private Stack<String> equiposParticipantes;
    private int capacidad;
    private int entradasVendidas;
    private String estado;

    public EventoResponse(EventoDAO evento, Map<Integer, String> equiposParticipantesMap) {
        this.id = evento.getId();
        this.nombre = evento.getNombre();
        this.fecha = evento.getFecha();
        this.lugar = evento.getLugar();
        this.deporte = evento.getDeporte();

        this.equiposParticipantes = new Stack<>();
        for (int idEquipo : evento.getEquiposParticipantes()) {
            this.equiposParticipantes.push(equiposParticipantesMap.getOrDefault(idEquipo, "Desconocido"));
        }

        this.capacidad = evento.getCapacidad();
        this.entradasVendidas = evento.getEntradasVendidas();
        this.estado = evento.getEstado();
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getFecha() {
        return fecha;
    }

    public String getLugar() {
        return lugar;
    }

    public String getDeporte() {
        return deporte;
    }

    public Stack<String> getEquiposParticipantes() {
        return equiposParticipantes;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public int getEntradasVendidas() {
        return entradasVendidas;
    }

    public String getEstado() {
        return estado;
    }
}
