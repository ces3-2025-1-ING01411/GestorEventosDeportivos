package co.edu.poli.ces3.gestoreventosdeportivos.servlet;

import co.edu.poli.ces3.gestoreventosdeportivos.dao.EquipoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.EventoDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dao.JugadorDAO;
import co.edu.poli.ces3.gestoreventosdeportivos.dto.EventoResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.services.EventoService;
import co.edu.poli.ces3.gestoreventosdeportivos.services.JugadorService;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.ApiResponse;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.RequestUtils;
import co.edu.poli.ces3.gestoreventosdeportivos.utils.UniqueIDGenerator;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "eventoServlet", value = "/eventos/*")
    public class EventoServlet extends HttpServlet {
    private Stack<EventoDAO> eventos;
    private Stack<EquipoDAO> equipos;
    private Stack<JugadorDAO> jugadores;

    public void init() {
        System.out.println("Init EquipoServlet!!");

        this.eventos = (Stack<EventoDAO>) getServletContext().getAttribute("eventos");

        //this.equipos = new Stack<>();
        this.equipos = (Stack<EquipoDAO>) getServletContext().getAttribute("equipos");

        //obtener lista jugadores en el contexto de la app
        this.jugadores = (Stack<JugadorDAO>) getServletContext().getAttribute("jugadores");

    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        //Crear mapa de id->nombre de los equipos
        Map<Integer, String> equiposMap = new HashMap<>();
        for (EquipoDAO e : equipos) {
            equiposMap.put(e.getId(), e.getNombre());
        }

//        Map<String, String[]> parameterMap = req.getParameterMap();
//        System.out.println(parameterMap);

//        for (String param : parameterMap.keySet()) {
//            System.out.println("parametro: " + param + " -> valor: " + Arrays.toString(parameterMap.get(param)));
//
//        }


        //definir parametros
        String idParam = req.getParameter("id");
        String deporte = req.getParameter("deporte");
        String estado = req.getParameter("estado");
        String fechaInicio = req.getParameter("fechaInicio");
        String fechaFin = req.getParameter("fechaFin");

        //evento por id
        if (idParam != null) {
            try {
                int idEvento = Integer.parseInt(idParam);
                for (EventoDAO e : eventos) {
                    if (e.getId() == idEvento) {
                        EventoResponse eventoResponse = new EventoResponse(e, equiposMap);
                        RequestUtils.sendJsonResponse(
                                resp,
                                HttpServletResponse.SC_OK,
                                eventoResponse
                        );
                        return;
                    }
                }

                // si no encontramos el evento con ese id
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_NOT_FOUND,
                        new ApiResponse("error", "El evento con id: " + idEvento + " no existe.")
                );
            } catch (NumberFormatException e) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error","El id del evento debe ser un numero entero.")
                );
            }

            return;
        }

        //convertir eventos a respuesta esperada(dto)
        Stack<EventoResponse> eventoResponses = new Stack<>();
        for (EventoDAO e : eventos) {
            eventoResponses.push(new EventoResponse(e, equiposMap));

            //obtener info de equipos
            //Stack<Integer> equiposParticipantes = eventoActual.getEquiposParticipantes();


        }

        //eventos con filtros
        if (deporte != null || estado != null || fechaInicio != null || fechaFin != null) {
            Stack<EventoResponse> eventosFiltrados =  EventoService.filtrarEventos(eventoResponses, deporte, estado, fechaInicio, fechaFin);
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_OK,
                    eventosFiltrados
            );
            return;
        }

//        req.setAttribute("eventos", eventoResponses);
//        RequestDispatcher dispatcher = req.getRequestDispatcher("/eventos.jsp");
//        dispatcher.forward(req, resp);

        //todos los eventos
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_OK,
                eventoResponses
        );
    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonObject requestBody = RequestUtils.getParamsFromBody(req);

        if (requestBody == null ||
                !requestBody.has("nombre") || requestBody.get("nombre").getAsString().trim().isEmpty() ||
                !requestBody.has("fecha") || requestBody.get("fecha").getAsString().trim().isEmpty() ||
                !requestBody.has("lugar") || requestBody.get("lugar").getAsString().trim().isEmpty() ||
                !requestBody.has("deporte") || requestBody.get("deporte").getAsString().trim().isEmpty() ||
                !requestBody.has("equiposParticipantes") || requestBody.get("equiposParticipantes").getAsJsonArray().size() == 0 ||
                !requestBody.has("capacidad") || !RequestUtils.isInteger(requestBody.get("capacidad")) ||
                !requestBody.has("entradasVendidas") || !RequestUtils.isInteger(requestBody.get("entradasVendidas")) ||
                !requestBody.has("estado") || requestBody.get("estado").getAsString().trim().isEmpty()
        ) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","Información para registrar un evento incompleta.")
            );
            return;
        }

        // validar que los equipos existen y que son del mismo deporte
        JsonArray jsonEquipos = requestBody.get("equiposParticipantes").getAsJsonArray();
        if (jsonEquipos.size() < 2) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","El evento debe tener como minimo 2 equipos participantes.")
            );
            return;
        }

        //validar que los equipos del evento sean del mismo deporte
        Set<String> deportesEvento = new HashSet<>();
        List<EquipoDAO> equiposSeleccionados = new ArrayList<>();

        for (JsonElement idEquipoEvento: jsonEquipos) {
            int idEquipo = idEquipoEvento.getAsInt();
            boolean equipoEncontrado = false;

            for (EquipoDAO equipo : equipos) {
                if (equipo.getId() == idEquipo) {
                    deportesEvento.add(equipo.getDeporte());
                    equiposSeleccionados.add(equipo);
                    equipoEncontrado = true;
                    break;
                }
            }

            if (!equipoEncontrado) {
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error", "El equipo con ID " + idEquipo + " no existe.")
                );
                return;
            }
        }

        // si hay más de un deporte en la lista, los equipos no son del mismo deporte
        if (deportesEvento.size() > 1) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error","Los equipos deben tener el mismo deporte.")
            );
            return;
        }

        //Crear evento
        EventoDAO evento = new EventoDAO();
        evento.setId(UniqueIDGenerator.generateEventoID());
        evento.setNombre(requestBody.get("nombre").getAsString());
        evento.setFecha(requestBody.get("fecha").getAsString());
        evento.setLugar(requestBody.get("lugar").getAsString());
        evento.setDeporte(requestBody.get("deporte").getAsString());
        evento.setCapacidad(requestBody.get("capacidad").getAsInt());
        evento.setEntradasVendidas(requestBody.get("entradasVendidas").getAsInt());
        evento.setEstado(requestBody.get("estado").getAsString());

        //agregar equiposParticipantes
        for (int i = 0; i < jsonEquipos.size(); i++) {
            evento.agregarEquiposParticipantes(jsonEquipos.get(i).getAsInt());
        }

        //agregar evento
        this.eventos.push(evento);

        //respuesta
        RequestUtils.sendJsonResponse(
                resp,
                HttpServletResponse.SC_CREATED,
                new ApiResponse("success","Evento " + evento.getNombre() + " creado con exito.")
        );
    }

    @Override
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

//        System.out.println(req.getServletPath());
//        System.out.println(req.getPathInfo());

        if (!RequestUtils.validateParams(resp, req.getParameter("eventoId"), "El id del evento es obligatorio.")) return;

        int idEvento;
        try {
            idEvento = Integer.parseInt(req.getParameter("eventoId"));
        } catch (NumberFormatException ex) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    new ApiResponse("error", "El ID del evento debe ser un número válido.")
            );
            return;
        }


        //buscar evento
        EventoDAO eventoActual = null;
        for (EventoDAO e : eventos) {
            if (e.getId() == idEvento){
                eventoActual = e;
                break;
            }
        }

        //validar que si exisat el eventoi
        if (eventoActual == null) {
            RequestUtils.sendJsonResponse(
                    resp,
                    HttpServletResponse.SC_NOT_FOUND,
                    new ApiResponse("error","No se encontró el evento con ID: " + idEvento)
            );
            return;
        }

        // manejo de rutas
        switch (pathInfo != null ? pathInfo : "") {
            case "":
                JsonObject requestBody = RequestUtils.getParamsFromBody(req);
                EventoService.actualizarEvento(eventoActual, requestBody, resp, equipos);
                break;
            case "/vender-entradas":
                EventoService.venderEntradas(eventoActual, req,resp);
                break;
            case "/actualizar-estado":
                EventoService.actualizarEstado(eventoActual, req,resp);
                break;
            default:
                RequestUtils.sendJsonResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        new ApiResponse("error", "Ruta inválida.")
                );
        }

//        if (pathInfo == null) {
//            //actualizar por id -> pathInfo=null
//
////            if (requestBody.has("nombre")) {
////                eventoActual.setNombre(requestBody.get("nombre").getAsString());
////            }
////            if (requestBody.has("fecha")) {
////                eventoActual.setFecha(requestBody.get("fecha").getAsString());
////            }
////            if (requestBody.has("lugar")) {
////                eventoActual.setLugar(requestBody.get("lugar").getAsString());
////            }
////            if (requestBody.has("deporte")) {
////                eventoActual.setDeporte(requestBody.get("deporte").getAsString());
////            }
////            if (requestBody.has("equiposParticipantes")) {
////                JsonArray equiposParticipantesActual = requestBody.get("equiposParticipantes").getAsJsonArray();
////                if (equiposParticipantesActual.size() < 2){
////                    RequestUtils.sendJsonResponse(
////                            resp,
////                            HttpServletResponse.SC_BAD_REQUEST,
////                            new ApiResponse("error","El evento debe tener como minimo 2 equipos participantes.")
////                    );
////                    return;
////                }
////
////                Stack equiposActualizar = new Stack<>();
////                for (JsonElement elemt : equiposParticipantesActual) {
////                    equiposActualizar.push(elemt.getAsInt());
////                }
////                eventoActual.setEquiposParticipantes(equiposActualizar);
////            }
////            if (requestBody.has("capacidad")) {
////                eventoActual.setCapacidad(requestBody.get("capacidad").getAsInt());
////            }
////            RequestUtils.sendJsonResponse(
////                    resp,
////                    HttpServletResponse.SC_OK,
////                    new ApiResponse("success","Evento actualizado..")
////            );
////            return;
//
//        } else if (pathInfo.equals("/vender-entradas")) {
//            //vender-entradas pathInfo=/vender-entradas
//
////            if (!RequestUtils.validateParams(resp,req.getParameter("cantidad"), "La nueva cantidad del evento es obligatoria.")) {
////                return;
////            }
////
////            int cantidad =  Integer.parseInt(req.getParameter("cantidad"));
////
////            int totalEntradasDisponibles = eventoActual.getCapacidad() - eventoActual.getEntradasVendidas();
////            if (cantidad > totalEntradasDisponibles) {
////                RequestUtils.sendJsonResponse(
////                        resp,
////                        HttpServletResponse.SC_BAD_REQUEST,
////                        new ApiResponse("error","El evento no tiene suficiente entradas disponibles.")
////                );
////                return;
////            }
////
////            eventoActual.setEntradasVendidas(eventoActual.getEntradasVendidas() + cantidad);
////            RequestUtils.sendJsonResponse(
////                    resp,
////                    HttpServletResponse.SC_OK,
////                    new ApiResponse("success","Las " + cantidad + " entradas para el evento " + eventoActual.getNombre() + " se vendieron con exito.")
////            );
////            return;
//
//        } else if (pathInfo.equals("/actualizar-estado")) {
//            //actualizar-estado pathInfo=/actualizar-estado
////            if (!RequestUtils.validateParams(resp, req.getParameter("estado"), "La nueva estado del evento es obligatorio.")) {
////                return;
////            }
////
////            String estado =  req.getParameter("estado");
////            eventoActual.setEstado(estado);
////
////            RequestUtils.sendJsonResponse(
////                    resp,
////                    HttpServletResponse.SC_OK,
////                    new ApiResponse("success","Se ha actualiza a estado '" + estado + "' el evento " + eventoActual.getNombre() + " con exito.")
////            );
////            return;
//
//        } else {
//            RequestUtils.sendJsonResponse(
//                    resp,
//                    HttpServletResponse.SC_BAD_REQUEST,
//                    new ApiResponse("error", "Ruta inválida.")
//            );
//        }
    }
}
