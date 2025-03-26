package co.edu.poli.ces3.gestoreventosdeportivos.services;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EventoResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Stack;
import java.util.stream.Collectors;

public class JugadorService {

    private Stack<JugadorDAO> jugadores;
    private Stack<EquipoDAO> equipos;

    public JugadorService(Stack<JugadorDAO> jugadores, Stack<EquipoDAO> equipos) {
        this.jugadores = jugadores;
        this.equipos = equipos;
    }

    public ApiResponse transferirJugador(int idJugador, int idEquipoDestino) throws IOException {
        System.out.println("Comenzando transferencia..");

        JugadorDAO jugador = null;
        EquipoDAO equipoDestino = null;
        EquipoDAO equipoActual = null;

        // buscar jugadro
        for (JugadorDAO j : jugadores) {
            if (j.getId() == idJugador) {
                jugador = j;
                break;
            }
        }

        // validar que el jugador exissta+
        if (jugador == null) {
            return new ApiResponse("error", "El jugador con id: " + idJugador + " no existe.");
        }

        //buscar equipo destino y equipo actual
        for (EquipoDAO e : equipos) {
            if (e.getId() == idEquipoDestino) {
                equipoDestino = e;
            }
            if (e.getId() == jugador.getEquipoId()) {
                equipoActual = e;
            }
        }

        // validar que los equipos existan
        if (equipoActual == null) {
            return new ApiResponse("error", "El equipo actual con id: "+ jugador.getEquipoId() + " no existe");
        }
        if (equipoDestino == null) {
            return new ApiResponse("error", "El equipo destino con id: "+ idEquipoDestino + " no existe");
        }

        // remover jugador del equiupo actual
        if (equipoActual != null) {
            equipoActual.removerJugador(jugador.getId());
        }

        // agregar jugador al equipo destino
        if (equipoDestino != null) {
            equipoDestino.agregarJugador(jugador.getId());
        }

        //actualizar el idEquipo del jugador
        jugador.setEquipoId(equipoDestino.getId());

        return new ApiResponse("success", "Jugador trasferido con exito del equipo: "+ equipoActual.getNombre() + " al nuevo equipo " + equipoDestino.getNombre());
    }

}
