package co.edu.poli.ces3.gestoreventosdeportivos.servlet;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EquipoResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EstadisticasResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.JugadorBasico;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "estadisticasServlet", value = "/estadisticas")
public class EstadisticasServlet extends HttpServlet {

    private Stack<JugadorDAO> jugadores;
    private Stack<EquipoDAO> equipos;

    private Stack<EventoDAO> eventos;

    public void init() {
        this.jugadores = (Stack<JugadorDAO>) getServletContext().getAttribute("jugadores");
        this.equipos = (Stack<EquipoDAO>) getServletContext().getAttribute("equipos");
        this.eventos = (Stack<EventoDAO>) getServletContext().getAttribute("eventos");

    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        EstadisticasResponse estadisticas = new EstadisticasResponse(
                eventosPorDeporte(eventos),
                promedioJugadoresPorEquipo(equipos),
                equiposConMasEventos(eventos, equipos),
                porcentajeOcupacionEvento(eventos)
        );

        //respuesta
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_OK,
                estadisticas
        );
    }

    private Map<String, Integer> eventosPorDeporte(Stack<EventoDAO> eventos) {

        Map<String, Integer> cantidadEventos = new HashMap<>();
        for (EventoDAO e : eventos) {
            cantidadEventos.put(e.getDeporte(), cantidadEventos.getOrDefault(e.getDeporte(), 0) + 1);
        }

        return cantidadEventos;
    }

    private double promedioJugadoresPorEquipo(Stack<EquipoDAO> equipos) {
        // contar el total de jugadores de todos los equipos y dividirlo por la cantidad de equipos.

        if (equipos.isEmpty()) return 0;

        int totalJugadores = 0;

        for (EquipoDAO e : equipos) {
            totalJugadores += e.getJugadores().size();
        }

        return (double) totalJugadores / equipos.size();

    }
    private List<EquipoResponse> equiposConMasEventos(Stack<EventoDAO> eventos, Stack<EquipoDAO> equipos) {

        Map<Integer, Integer> eventosPorEquipo = new HashMap<>();

        // contar eventos por equipo
        for (EventoDAO ev : eventos) {
            for (int idEquipo : ev.getEquiposParticipantes()) {
                eventosPorEquipo.put(idEquipo, eventosPorEquipo.getOrDefault(idEquipo, 0) + 1);
            }
        }

        // buscar maximo numero de eventos
//        int maxEventos = 0;
//        for (int eventosEquipo : eventosPorEquipo.values()) {
//            if (eventosEquipo > maxEventos) {
//                maxEventos = eventosEquipo;
//            }
//        }
        int maxEventos = eventosPorEquipo.values().stream()
                .max(Integer::compare)
                .orElse(0);

        //buscar equipos con el maximo numero de eventos
        List<EquipoResponse> equiposMasEventos = new ArrayList<>();
        for (EquipoDAO eq : equipos) {
            int eventosEquipo = eventosPorEquipo.getOrDefault(eq.getId(), 0);
            if (eventosEquipo == maxEventos) {

                //lista con info de jugadores
                List<JugadorBasico> jugadoresActual = eq.getJugadores().stream()
                                .map(idJugadorActual -> jugadores.stream()
                                        .filter(j -> j.getId() == idJugadorActual)
                                        .findFirst()
                                        .orElse(null))
                                .filter(Objects::nonNull)
                                .map(JugadorBasico::new)
                                .collect(Collectors.toList());

                equiposMasEventos.add(new EquipoResponse(eq, jugadoresActual));
            }
        }
        return equiposMasEventos;
    }

    private Map<String, String> porcentajeOcupacionEvento(Stack<EventoDAO> eventos) {
//        System.out.println("Calcular..");

        Map<String, String> ocupacionEvento = new HashMap<>();
        for (EventoDAO ev : eventos) {
            int entradasVendidas = ev.getEntradasVendidas();
            int capacidad = ev.getCapacidad();

            if (capacidad > 0) {
                int porcentaje = (int) Math.round((double) entradasVendidas / capacidad * 100);
                //double porcentaje = (double) entradasVendidas / capacidad * 100;
                ocupacionEvento.put(ev.getNombre(), porcentaje + "%");
            } else {
                ocupacionEvento.put(ev.getNombre(), "0%");
            }
        }

        return ocupacionEvento;
    }

}
