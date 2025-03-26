package co.edu.poli.ces3.gestoreventosdeportivos.servlet;

import java.io.*;
import java.util.Stack;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.JugadorResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.services.JugadorService;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.ApiResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.UniqueIDGenerator;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "jugadorServlet", value = "/jugadores/*")
public class JugadorServlet extends HttpServlet {
    private Stack<JugadorDAO> jugadores;
    private Stack<EquipoDAO> equipos;
    private JugadorService jugadorService;

    public void init() {
        System.out.println("Init jugadores!!");

        //this.jugadores = new Stack<>();

        this.jugadores = (Stack<JugadorDAO>) getServletContext().getAttribute("jugadores");

        this.equipos = (Stack<EquipoDAO>) getServletContext().getAttribute("equipos");
        if (this.equipos == null) {
            this.equipos = new Stack<>();
        }

        this.jugadorService = new JugadorService(jugadores, equipos);
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        System.out.println(req.getServletPath());
//        System.out.println(req.getPathInfo());
        //jugador a transferir
        if ("/transferir".equals(req.getPathInfo())) {
            //System.out.println("entra");
            try {
                int idJugador = Integer.parseInt(req.getParameter("jugadorId"));
                int idEquipoDestino = Integer.parseInt(req.getParameter("equipoDestino"));

                ApiResponse response = jugadorService.transferirJugador(idJugador, idEquipoDestino);
                RequestUtils.sendJsonResponse(resp, HttpServletResponse.SC_OK, response);
                return;
            } catch (NumberFormatException e) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","El jugadorId y equipoDestino deben ser numeros enteros.")
                );
                return;
            }
        }

        // jugador por id
        if (req.getParameter("id") != null) {
            try {
                int idJugador = Integer.parseInt((req.getParameter("id")));
                for (JugadorDAO j : jugadores) {
                    if (j.getId() == Math.abs(idJugador)) {
                        String equipoNombre = "Sin equipo";
                        for (EquipoDAO e : equipos) {
                            if (e.getId() == j.getEquipoId()) {
                                equipoNombre = e.getNombre();
                                break;
                            }
                        }

                        JugadorResponse jugadorResponse = new JugadorResponse(j, equipoNombre);
                        RequestUtils.sendJsonResponse(
                                resp,
                                HttpServletResponse.SC_OK,
                                jugadorResponse
                        );
                        return;
                    }
                }

                // si no encontramos el jugador con ese id
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_NOT_FOUND,
                        new ApiResponse("error", "El jugador con id: " + idJugador + " no existe.")
                );

            } catch (NumberFormatException ex) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","El id del jugador debe ser un numero entero.")
                );
            }
            return;
        }

        // todos los jugadores
        Stack<JugadorResponse> jugadorResponses = new Stack<>();
        for (JugadorDAO j : jugadores) {
            String nombreEquipo = "Sin asignar";
            for (EquipoDAO e : equipos) {
                if (j.getEquipoId() == e.getId()) {
                    nombreEquipo = e.getNombre();
                    break;
                }
            }
            jugadorResponses.push(new JugadorResponse(j, nombreEquipo));

        }
        //EquipoResponse equipoResponse = new EquipoResponse();
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_OK,
                jugadorResponses
        );
    }

    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonObject requestBody = RequestUtils.getParamsFromBody(req);

        if (requestBody == null ||
                !requestBody.has("nombre") || requestBody.get("nombre").getAsString().trim().isEmpty() ||
                !requestBody.has("apellido") || requestBody.get("apellido").getAsString().trim().isEmpty() ||
                !requestBody.has("fechaNacimiento") || requestBody.get("fechaNacimiento").getAsString().trim().isEmpty() ||
                !requestBody.has("nacionalidad") || requestBody.get("nacionalidad").getAsString().trim().isEmpty() ||
                !requestBody.has("posicion") || requestBody.get("posicion").getAsString().trim().isEmpty() ||
                !requestBody.has("numero") || !RequestUtils.isInteger(requestBody.get("numero")) ||
                !requestBody.has("equipoId") || !RequestUtils.isInteger(requestBody.get("equipoId")) ||
                !requestBody.has("estadoActivo") || !RequestUtils.isBoolean(requestBody.get("estadoActivo"))
        ) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","Información para registrar un jugador incompleta.")
            );
            return;
        }

        // validar qe no exista otro jugador con el mismo número en el mismo equipo
        int numero = requestBody.get("numero").getAsInt();
        int equipo = requestBody.get("equipoId").getAsInt();

        for (JugadorDAO j : jugadores) {
            if (j.getNumero() == numero && j.getEquipoId() == equipo) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error", "Ya existe un jugador con el numero '" + numero + "' y equipo '" + equipo + "'.")
                );
                return;
            }
        }

        // Obtener equipo a actualizar con nuevo jugador
        EquipoDAO equipoActualizar = null;
        for (EquipoDAO e: equipos) {
            if (e.getId() == equipo) {
                equipoActualizar = e;
                break;
            }
        }

        //validar que exista el equuipo
        if (equipoActualizar == null) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error", "El equipo con id '" + equipo + "' no existe.")
            );
            return;
        }

        //registrar nuevo jugador
        JugadorDAO jugador = new JugadorDAO();
        jugador.setId(UniqueIDGenerator.generateJugadorID());
        jugador.setNombre(requestBody.get("nombre").getAsString());
        jugador.setApellido(requestBody.get("apellido").getAsString());
        jugador.setFechaNacimiento(requestBody.get("fechaNacimiento").getAsString());
        jugador.setNacionalidad(requestBody.get("nacionalidad").getAsString());
        jugador.setPosicion(requestBody.get("posicion").getAsString());
        jugador.setNumero(requestBody.get("numero").getAsInt());
        jugador.setEquipoId(equipo);
        jugador.setEstadoActivo(requestBody.get("estadoActivo").getAsBoolean());
        //aggregar
        this.jugadores.push(jugador);

        //actualizar equipo con este nuvo jugador
        equipoActualizar.agregarJugador(jugador.getId());

        //respuesta
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_CREATED,
                new ApiResponse("success","Jugador " + jugador.getNombre() + " " + jugador.getApellido() + " creado con exito en el equipo " + equipoActualizar.getNombre())
        );
    }

    @Override
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("A actualizaar...");

        JsonObject requestBody = RequestUtils.getParamsFromBody(req);

        if(!RequestUtils.validateParams(resp, req.getParameter("id"), "El id del jugador es obligatorio.")) {
            return;
        }

        //obtener jugador
        int idJugador = Integer.parseInt(req.getParameter("id"));
        JugadorDAO jugadorActual = null;
        for (JugadorDAO j : jugadores) {
            if (j.getId() == idJugador) {
                jugadorActual = j;
                break;
            }
        }

        if (jugadorActual == null) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_NOT_FOUND,
                    new ApiResponse("error","No se encontró el jugador con ID: " + idJugador)
            );
            return;
        }

        if (requestBody.has("nombre")) {
            jugadorActual.setNombre(requestBody.get("nombre").getAsString());
        }
        if (requestBody.has("apellido")) {
            jugadorActual.setApellido(requestBody.get("apellido").getAsString());
        }
        if (requestBody.has("fechaNacimiento")) {
            jugadorActual.setFechaNacimiento(requestBody.get("fechaNacimiento").getAsString());
        }
        if (requestBody.has("nacionalidad")) {
            jugadorActual.setNacionalidad(requestBody.get("nacionalidad").getAsString());
        }
        if (requestBody.has("posicion")) {
            jugadorActual.setPosicion(requestBody.get("posicion").getAsString());
        }
        if (requestBody.has("numero")) {
            jugadorActual.setNumero(requestBody.get("numero").getAsInt());
        }
        if (requestBody.has("estadoActivo")) {
            jugadorActual.setEstadoActivo(requestBody.get("estadoActivo").getAsBoolean());
        }

        //Respuesta
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_CREATED,
                new ApiResponse("success","Jugador editado con exito.")
        );

        //actualizar equipos NO(es en transferencia)

    }

    public void destroy() {
    }
}