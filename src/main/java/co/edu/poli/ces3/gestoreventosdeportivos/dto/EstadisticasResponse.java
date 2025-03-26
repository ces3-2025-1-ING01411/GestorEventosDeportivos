package co.edu.poli.ces3.gestoreventosdeportivos.dto;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;

import java.util.List;
import java.util.Map;
import java.util.List;

public class EstadisticasResponse {
    private Map<String, Integer> eventosPorDeporte;
    private double promedioJugadoresPorEquipo;
    private List<EquipoResponse> equiposConMasEventos;
    private Map<String, String> porcentajeOcupacionEvento;

    public EstadisticasResponse() {
    }

    public EstadisticasResponse(Map<String, Integer> eventosPorDeporte, double promedioJugadoresPorEquipo, List<EquipoResponse> equiposConMasEventos, Map<String, String> porcentajeOcupacionEvento) {
        this.eventosPorDeporte = eventosPorDeporte;
        this.promedioJugadoresPorEquipo = promedioJugadoresPorEquipo;
        this.equiposConMasEventos = equiposConMasEventos;
        this.porcentajeOcupacionEvento = porcentajeOcupacionEvento;
    }

    public Map<String, Integer> getEventosPorDeporte() {
        return eventosPorDeporte;
    }

    public void setEventosPorDeporte(Map<String, Integer> eventosPorDeporte) {
        this.eventosPorDeporte = eventosPorDeporte;
    }

    public double getPromedioJugadoresPorEquipo() {
        return promedioJugadoresPorEquipo;
    }

    public void setPromedioJugadoresPorEquipo(double promedioJugadoresPorEquipo) {
        this.promedioJugadoresPorEquipo = promedioJugadoresPorEquipo;
    }

    public List<EquipoResponse> getEquiposConMasEventos() {
        return equiposConMasEventos;
    }

    public void setEquiposConMasEventos(List<EquipoResponse> equiposConMasEventos) {
        this.equiposConMasEventos = equiposConMasEventos;
    }

    public Map<String, String> getPorcentajeOcupacionEvento() {
        return porcentajeOcupacionEvento;
    }

    public void setPorcentajeOcupacionEvento(Map<String, String> porcentajeOcupacionEvento) {
        this.porcentajeOcupacionEvento = porcentajeOcupacionEvento;
    }
}
